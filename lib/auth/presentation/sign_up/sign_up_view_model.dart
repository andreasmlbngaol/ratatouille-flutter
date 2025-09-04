import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_state.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/utils/view_model.dart';

class SignUpViewModel extends ViewModel {
  final ApiClient apiClient;
  final AuthService authService;
  final TokenManager tokenManager;

  SignUpViewModel({
    required this.apiClient,
    required this.authService,
    required this.tokenManager
  });

  SignUpState _state = const SignUpState();

  SignUpState get state => _state;

  void setName(String value) {
    _state = _state.copyWith(name: value);
    notifyListeners();
  }

  void setEmail(String value) {
    _state = _state.copyWith(email: value);
    notifyListeners();
  }
  void setPassword(String value) {
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _state = _state.copyWith(confirmPassword: value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(passwordVisible: !_state.passwordVisible);
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _state =
        _state.copyWith(confirmPasswordVisible: !_state.confirmPasswordVisible);
    notifyListeners();
  }

  void signUpWithEmailAndPassword({
    required Function() onSuccess
  }) async {
    debugPrint("Sign Up. Email: ${_state.email}, Password: ${_state.password}, Confirm Password: ${_state.confirmPassword}");
    try {
      final checkEmailRes = await apiClient.dio.post(
          "/auth/register/check-email",
          data: {
            "email": _state.email
          }
      );

      if (checkEmailRes.statusCode == null || checkEmailRes.statusCode != 200) {
        debugPrint("Email already registered");
        return;
      }

      debugPrint("Masih lanjut sampek sini");

      final credential = await authService.signUpWithEmailAndPassword(
          email: _state.email,
          password: _state.password
      );
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        final res = await signInToBackEnd(
            idToken: idToken,
            method: "EMAIL_AND_PASSWORD"
        );
        if (res.statusCode != null && res.statusCode! >= 200 &&
            res.statusCode! < 300) {
          await apiClient.dio.patch(
            "/users/name",
            data: {
              "name": _state.name
            }
          );
          onSuccess();
        }
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  void signInWithGoogle({
    required Function() onSuccess
  }) async {
    debugPrint("Sign In with Google");
    final credential = await authService.signInWithGoogle();
    final idToken = await credential?.user?.getIdToken();
    if (idToken != null) {
      final res = await signInToBackEnd(idToken: idToken, method: "GOOGLE");
      if(res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        onSuccess();
      }
    }
  }

  Future<Response> signInToBackEnd({
    required String idToken,
    required String method
  }) async {
    debugPrint("Sign In to Back End");
    debugPrint("ID Token: $idToken");
    debugPrint("Method: $method");

    final res = await apiClient.dio.post(
        "/auth/login",
        data: {
          "id_token": idToken,
          "method": method
        }
    );

    // debugPrint(res.data);

    final tokens = res.data["tokens"];

    final accessToken = tokens["access_token"];
    final refreshToken = tokens["refresh_token"];

    await tokenManager.saveTokens(accessToken, refreshToken);

    return res;
  }
}