import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/auth/presentation/state/sign_in_state.dart';
import 'package:moprog/auth/presentation/state/sign_up_state.dart';
import 'package:moprog/auth/presentation/view_model/sign_in_view_model.dart';
import 'package:moprog/auth/presentation/view_model/sign_up_view_model.dart';
import 'package:moprog/auth/presentation/view_model/splash_view_model.dart';
import 'package:moprog/core/data/di/getIt.dart';
import 'package:moprog/main/home/presentation/state/home_state.dart';
import 'package:moprog/main/home/presentation/view_model/home_view_model.dart';

/// Auth
final signInProvider = StateNotifierProvider<SignInViewModel, SignInState>((ref) {
  return SignInViewModel(repository: getIt());
});

final signUpProvider = StateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
  return SignUpViewModel(repository: getIt());
});

final splashProvider = StateNotifierProvider<SplashViewModel, dynamic>((ref) {
  return SplashViewModel(repository: getIt());
});

/// Main
final homeProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(authRepository: getIt(), apiClient: getIt());
});
