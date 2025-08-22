import 'package:get_it/get_it.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/auth/presentation/sign_in/sign_in_view_model.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_view_model.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/presentation/splash/splash_view_model.dart';
import 'package:moprog/main/presentation/home/home_view_model.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  final tokenManager = TokenManager();
  await tokenManager.init();

  // Singleton
  getIt.registerSingleton<TokenManager>(tokenManager);
  getIt.registerSingleton<ApiClient>(ApiClient(tokenManager: getIt()));
  getIt.registerSingleton<AuthService>(AuthService(tokenManager: getIt()));

  // VM Factory
  getIt.registerFactory<SplashViewModel>(() => SplashViewModel(apiClient: getIt(), tokenManager: getIt()));
  getIt.registerFactory<SignInViewModel>(() => SignInViewModel(apiClient: getIt(), authService: getIt(), tokenManager: getIt()));
  getIt.registerFactory<SignUpViewModel>(() => SignUpViewModel(apiClient: getIt(), authService: getIt()));

  getIt.registerFactory<HomeViewModel>(() => HomeViewModel(authService: getIt()));
}
