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

  void _validateName(String name) {
    if (name.isEmpty) {
      _state = _state.copyWith(nameError: "Nama tidak boleh kosong");
    } else {
      _state = _state.copyWith(nameError: null);
    }
  }
  void setName(String value) {
    _state = _state.copyWith(name: value);
    _validateName(value);
    notifyListeners();
  }

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
  void setEmail(String value) {
    _state = _state.copyWith(email: value);
    _validateEmail(value);
    notifyListeners();
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      _state = _state.copyWith(passwordError: "Password tidak boleh kosong");
    } else if (password.length < 8) {
      _state = _state.copyWith(passwordError: "Password minimal 8 karakter");
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      _state = _state.copyWith(passwordError: "Password harus mengandung huruf besar");
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      _state = _state.copyWith(passwordError: "Password harus mengandung huruf kecil");
    } else if (!RegExp(r'\d').hasMatch(password)) {
      _state = _state.copyWith(passwordError: "Password harus mengandung angka");
    } else {
      _state = _state.copyWith(passwordError: null);
    }
  }
  void setPassword(String value) {
    _state = _state.copyWith(password: value);
    _validatePassword(value);
    notifyListeners();
  }

  void _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _state = _state.copyWith(
          confirmPasswordError: "Konfirmasi password tidak boleh kosong");
    } else if (confirmPassword != _state.password) {
      _state = _state.copyWith(
          confirmPasswordError: "Konfirmasi password tidak sama dengan password");
    } else {
      _state = _state.copyWith(confirmPasswordError: null);
    }
  }
  void setConfirmPassword(String value) {
    _state = _state.copyWith(confirmPassword: value);
    _validateConfirmPassword(value);
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
    required Function() onNavigateToHome,
    required Function() onNavigateToVerification,
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
        final tempRes = await repository.login(LoginRequest(idToken: idToken, method: AuthMethod.EMAIL_AND_PASSWORD));
        if(tempRes == null) {
          debugPrint("Error logging in");
          onFailed("Gagal login");
          return;
        }

        await tokenManager.saveData(tempRes);

        await repository.changeName(_state.name);
        final finalRes = await repository.login(LoginRequest(idToken: idToken, method: AuthMethod.EMAIL_AND_PASSWORD));
        await tokenManager.clearTokens();
        if(finalRes == null) {
          debugPrint("Error logging in");
          onFailed("Gagal login");
          return;
        }

        await tokenManager.saveData(finalRes);
        debugPrint(tokenManager.user.toString());
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