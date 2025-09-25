import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/auth/presentation/state/sign_in_state.dart';
import 'package:moprog/auth/presentation/state/sign_up_state.dart';
import 'package:moprog/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:moprog/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:moprog/auth/presentation/view_model/splash_view_model.dart';
import 'package:moprog/core/data/di/get_it.dart';
import 'package:moprog/main/container/presentation/state/home_state.dart';
import 'package:moprog/main/container/presentation/view_model/home_view_model.dart';

/// Auth
final signInProvider = StateNotifierProvider.autoDispose<SignInViewModel, SignInState>((ref) {
  return SignInViewModel(repository: getIt());
});

final signUpProvider = StateNotifierProvider.autoDispose<SignUpViewModel, SignUpState>((ref) {
  return SignUpViewModel(repository: getIt());
});

final splashProvider = StateNotifierProvider.autoDispose<SplashViewModel, dynamic>((ref) {
  return SplashViewModel(repository: getIt());
});

/// Main
final homeProvider = StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(authRepository: getIt(), apiClient: getIt());
});
