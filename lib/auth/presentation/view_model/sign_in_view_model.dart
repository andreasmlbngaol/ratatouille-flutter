import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/auth/data/repositories/auth_handler.dart';
import 'package:moprog/auth/data/repositories/auth_repository.dart';
import 'package:moprog/auth/domain/auth_result.dart';
import 'package:moprog/auth/presentation/state/sign_in_state.dart';

class SignInViewModel extends StateNotifier<SignInState> {
  final AuthRepository _repository;
  final AuthHandler _handler;

  SignInViewModel({required AuthRepository repository})
      : _repository = repository,
        _handler = AuthHandler(repository: repository),
        super(SignInState());

  void signInWithGoogle({
    required Function() onSuccess,
    required Function(String) onFailed
  }) async {
    await _handler.signInWithGoogle(onSuccess: onSuccess, onFailed: onFailed);
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

  void setEmail(String value) async {
    state = state.copyWith(email: value);
    _validateEmail(value);
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      state = state.copyWith(passwordError: "Password harus mengandung angka");
    } else {
      state = state.copyWith(passwordError: null);
    }
  }

  void setPassword(String value) async {
    state = state.copyWith(password: value);
    _validatePassword(value);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void signInWithEmailAndPassword({
    required Function() onNavigateToHome,
    required Function() onNavigateToVerification,
    required Function(String) onFailed
  }) async {
    final result = await _repository.signInWithEmailAndPassword(
        email: state.email,
        password: state.password
    );

    if(result is AuthSuccess) {
      result.isEmailVerified ? onNavigateToHome() : onNavigateToVerification();
    } else if(result is AuthFailed) {
      onFailed(result.message);
    }
  }
}