import 'package:flutter/cupertino.dart';
import 'package:moprog/auth/data/auth/auth_method.dart';
import 'package:moprog/auth/data/auth/login_request/login_request.dart';
import 'package:moprog/auth/presentation/auth_view_model.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_state.dart';

class SignUpViewModel extends AuthViewModel {
  SignUpViewModel({
    required super.repository,
    required super.authService,
    required super.tokenManager
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
    required Function() onSuccess,
    required Function(String) onFailed
  }) async {
    debugPrint("Sign Up. Email: ${_state.email}, Password: ${_state.password}, Confirm Password: ${_state.confirmPassword}");
    try {
      if(await repository.checkEmailAvailability(_state.email) == null) {
        debugPrint("Email already registered");
        onFailed("Email sudah terdaftar");
        return;
      }

      final credential = await authService.signUpWithEmailAndPassword(
          email: _state.email,
          password: _state.password
      );
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        final res = await repository.login(LoginRequest(idToken: idToken, method: AuthMethod.GOOGLE));
        if(res == null) {
          debugPrint("Error logging in");
          onFailed("Gagal login");
          return;
        }

        await tokenManager.saveTokens(res.tokens.accessToken, res.tokens.refreshToken);
        await repository.changeName(_state.name);
        onSuccess();
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }
}