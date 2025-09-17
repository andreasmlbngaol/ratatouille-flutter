import 'package:flutter/foundation.dart';
import 'package:moprog/auth/data/auth/auth_method.dart';
import 'package:moprog/auth/data/auth/login_request/login_request.dart';
import 'package:moprog/auth/presentation/auth_view_model.dart';
import 'package:moprog/auth/presentation/sign_in/sign_in_state.dart';

class SignInViewModel extends AuthViewModel {
  SignInViewModel({
    required super.repository,
    required super.tokenManager,
    required super.authService,
  });

  SignInState _state = const SignInState();

  SignInState get state => _state;

  void _validateEmail(String email) {
    if (email.isEmpty) {
      _state = _state.copyWith(emailError: "Email tidak boleh kosong");
    } else {
      final regex = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
      );
      if (!regex.hasMatch(email)) {
        _state = _state.copyWith(emailError: "Email tidak valid");
      } else {
        _state = _state.copyWith(emailError: null);
      }
    }
  }

  void setEmail(String value) async {
    _state = _state.copyWith(email: value);
    _validateEmail(value);
    notifyListeners();
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      _state = _state.copyWith(passwordError: "Password harus mengandung angka");
    } else {
      _state = _state.copyWith(passwordError: null);
    }
  }

  void setPassword(String value) async {
    _state = _state.copyWith(password: value);
    _validatePassword(value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(passwordVisible: !_state.passwordVisible);
    notifyListeners();
  }

  void signInWithEmailAndPassword({
    required Function() onNavigateToHome,
    required Function() onNavigateToVerification,
    required Function(String) onFailed
  }) async {
    debugPrint("Sign In. Email: ${_state.email}, Password: ${_state.password}");
    try {
      final credential = await authService.signInWithEmailAndPassword(
          email: _state.email,
          password: _state.password
      );
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        final res = await repository.login(LoginRequest(idToken: idToken, method: AuthMethod.EMAIL_AND_PASSWORD));
        if(res == null) {
          debugPrint("Error logging in");
          onFailed("Gagal login");
          return;
        }

        await tokenManager.saveData(res);
        if(tokenManager.user?.isEmailVerified == true) {
          onNavigateToHome();
        } else {
          onNavigateToVerification();
        }
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }
}