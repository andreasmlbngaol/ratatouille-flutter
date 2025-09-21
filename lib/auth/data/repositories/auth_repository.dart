import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:moprog/auth/data/models/login_request/login_request.dart';
import 'package:moprog/auth/data/models/login_response/login_response.dart';
import 'package:moprog/auth/data/services/backend_auth_service.dart';
import 'package:moprog/auth/data/services/firebase_auth_service.dart';
import 'package:moprog/auth/domain/auth_method.dart';
import 'package:moprog/auth/domain/auth_result.dart';
import 'package:moprog/auth/domain/check_auth_status.dart';
import 'package:moprog/core/data/model/token_manager.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final BackendAuthService _backendAuthService;
  final TokenManager _tokenManager;

  AuthRepository._({
    required FirebaseAuthService firebaseAuthService,
    required BackendAuthService backendAuthService,
    required TokenManager tokenManager
  }) :
        _firebaseAuthService = firebaseAuthService,
        _backendAuthService = backendAuthService,
        _tokenManager = tokenManager;

  factory AuthRepository.create(GetIt di) {
    return AuthRepository._(
      firebaseAuthService: di<FirebaseAuthService>(),
      backendAuthService: di<BackendAuthService>(),
      tokenManager: di<TokenManager>()
    );
  }
  Future<AuthResult> signInWithGoogle() async {
    debugPrint("Sign In with Google");
    final credential = await _firebaseAuthService.signInWithGoogle();
    final idToken = await credential?.user?.getIdToken();
    if (idToken != null) {
      final LoginResponse? res = await _backendAuthService.login(LoginRequest(idToken: idToken, method: AuthMethod.GOOGLE));
      if(res == null) {
        signOut();
        return AuthFailed(message: "Gagal. Silakan coba lagi.");
      }
      await _tokenManager.saveData(res);
      return AuthSuccess(isEmailVerified: true);
    }
    return AuthFailed(message: "Gagal login dengan Google");
  }

  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    debugPrint("Sign In. Email: $email, Password: $password");
    try {
      final credential = await _firebaseAuthService.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        final res = await _backendAuthService.login(LoginRequest(idToken: idToken, method: AuthMethod.EMAIL_AND_PASSWORD));
        if(res == null) {
          debugPrint("Error logging in");
          return AuthFailed(message: "Gagal login");
        }

        await _tokenManager.saveData(res);
        return AuthSuccess(isEmailVerified: _tokenManager.user?.isEmailVerified == true);
      }
      return AuthFailed(message: "Gagal login");
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return AuthFailed(message: "Gagal login");
    }
  }

  Future<AuthResult> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    debugPrint("Sign Up. Email: $email, Password: $password, Confirm Password: $confirmPassword");
    try {
      if(await _backendAuthService.checkEmailAvailability(email) == null) {
        debugPrint("Email already registered");
        return AuthFailed(message: "Email sudah terdaftar");
      }

      final credential = await _firebaseAuthService.signUpWithEmailAndPassword(
          email: email,
          password: password
      );
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        final tempRes = await _backendAuthService.login(LoginRequest(idToken: idToken, method: AuthMethod.EMAIL_AND_PASSWORD));
        if(tempRes == null) {
          debugPrint("Error logging in");
          return AuthFailed(message: "Gagal login");
        }

        await _tokenManager.saveData(tempRes);

        await _backendAuthService.changeName(name);
        final finalRes = await _backendAuthService.login(LoginRequest(idToken: idToken, method: AuthMethod.EMAIL_AND_PASSWORD));
        await _tokenManager.clearTokens();
        if(finalRes == null) {
          debugPrint("Error logging in");
          return AuthFailed(message: "Gagal login");
        }

        await _tokenManager.saveData(finalRes);
        debugPrint(_tokenManager.user.toString());
        return AuthSuccess(isEmailVerified: _tokenManager.user?.isEmailVerified == true);
      }
      return AuthFailed(message: "Gagal login");
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return AuthFailed(message: "Gagal login");
    }
  }

  Future<CheckAuthStatus> checkAuthStatus() async {
    await _tokenManager.init(); /// Ini yang harusnya ada di dependency_injection, biar gak kelamaan startup disini aja

    // Step 1: Cek koneksi internet
    final hasInternet = await InternetConnectionChecker.instance.hasConnection;
    if(!hasInternet) {
      debugPrint("checkAuthUser: No Internet Connection");
      return CheckAuthStatus.noInternet;
    }

    // Step 2: Cek apakah user sudah login atau belum
    if (_tokenManager.refreshToken != null && _tokenManager.accessToken != null) {
      debugPrint("checkAuthUser: Refresh Token and Access Token found");
      final ping = await _backendAuthService.ping();
      if(ping == 200) {
        debugPrint("checkAuthUser: /ping-protected success");
        return CheckAuthStatus.authenticated;

        // Ini abaikan dulu, ada bug nya
        // if(_tokenManager.user?.isEmailVerified == true) {
        //   onAuthenticated();
        // } else {
        //   onNavigateToVerification();
        // }
        // return;
      } else {
        if(ping > 500) {
          debugPrint("checkAuthUser: Server Error");
          return CheckAuthStatus.serverError;
        } else {
          debugPrint("checkAuthUser: Refresh Token and Access Token invalid");
          signOut();
          return CheckAuthStatus.unauthenticated;
        }
      }
    }

    // Step 3: Jika tidak ada refresh token atau access token, langsung sign out
    debugPrint("checkAuthUser: Refresh Token and Access Token not found");
    signOut();
    return CheckAuthStatus.unauthenticated;
  }

  void signOut() async {
    await _firebaseAuthService.signOut();
    await _tokenManager.clearTokens();
  }
}