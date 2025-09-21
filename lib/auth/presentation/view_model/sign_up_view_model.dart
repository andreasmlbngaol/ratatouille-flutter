import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/auth/data/repositories/auth_handler.dart';
import 'package:moprog/auth/data/repositories/auth_repository.dart';
import 'package:moprog/auth/domain/auth_result.dart';
import 'package:moprog/auth/presentation/state/sign_up_state.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  final AuthRepository _repository;
  final AuthHandler _handler;

  SignUpViewModel({required AuthRepository repository})
      : _repository = repository,
        _handler = AuthHandler(repository: repository),
        super(SignUpState());

  void signInWithGoogle({
    required Function() onSuccess,
    required Function(String) onFailed
  }) async {
    await _handler.signInWithGoogle(onSuccess: onSuccess, onFailed: onFailed);
  }

  void _validateName(String name) {
    if (name.isEmpty) {
      state = state.copyWith(nameError: "Nama tidak boleh kosong");
    } else {
      state = state.copyWith(nameError: null);
    }
  }
  void setName(String value) {
    state = state.copyWith(name: value);
    _validateName(value);
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      state = state.copyWith(emailError: "Email tidak boleh kosong");
    } else {
      final regex = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
      );
      if (!regex.hasMatch(email)) {
        state = state.copyWith(emailError: "Email tidak valid");
      } else {
        state = state.copyWith(emailError: null);
      }
    }
  }
  void setEmail(String value) {
    state = state.copyWith(email: value);
    _validateEmail(value);
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      state = state.copyWith(passwordError: "Password tidak boleh kosong");
    } else if (password.length < 8) {
      state = state.copyWith(passwordError: "Password minimal 8 karakter");
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      state = state.copyWith(passwordError: "Password harus mengandung huruf besar");
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      state = state.copyWith(passwordError: "Password harus mengandung huruf kecil");
    } else if (!RegExp(r'\d').hasMatch(password)) {
      state = state.copyWith(passwordError: "Password harus mengandung angka");
    } else {
      state = state.copyWith(passwordError: null);
    }
  }
  void setPassword(String value) {
    state = state.copyWith(password: value);
    _validatePassword(value);
  }

  void _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      state = state.copyWith(
          confirmPasswordError: "Konfirmasi password tidak boleh kosong");
    } else if (confirmPassword != state.password) {
      state = state.copyWith(
          confirmPasswordError: "Konfirmasi password tidak sama dengan password");
    } else {
      state = state.copyWith(confirmPasswordError: null);
    }
  }
  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
    _validateConfirmPassword(value);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state =
        state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible);
  }

  void signUpWithEmailAndPassword({
    required Function() onNavigateToHome,
    required Function() onNavigateToVerification,
    required Function(String) onFailed
  }) async {
    final result = await _repository.signUpWithEmailAndPassword(
        name: state.name,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
    );
    if(result is AuthSuccess) {
      result.isEmailVerified ? onNavigateToHome() : onNavigateToVerification();
    } else if(result is AuthFailed) {
      onFailed(result.message);
    }
  }
}