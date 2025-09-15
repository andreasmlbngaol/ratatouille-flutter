import 'package:get_it/get_it.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/auth/model/ratatouille_repository.dart';
import 'package:moprog/auth/presentation/sign_in/sign_in_view_model.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_view_model.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/presentation/splash/splash_view_model.dart';
import 'package:moprog/main/presentation/home/home_view_model.dart';

/// Ini objek dari dependency injector nya
final getIt = GetIt.instance;

Future<void> setupDi() async {
  /// Panggil di dalam SplashViewModel biar gak kelamaan startup nya
  // await tokenManager.init();

  /// Singleton object biar gampang inject di semua ViewModel
  getIt.registerLazySingleton<TokenManager>(() => TokenManager());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(tokenManager: getIt()));
  getIt.registerLazySingleton<AuthService>(() => AuthService(tokenManager: getIt()));
  getIt.registerLazySingleton<RatatouilleRepository>(() => RatatouilleRepository(apiClient: getIt()));

  /// ViewModelFactory yang langsung di inject dependency-nya
  getIt.registerFactory<SplashViewModel>(() => SplashViewModel(apiClient: getIt(), tokenManager: getIt(), authService: getIt()));
  getIt.registerFactory<SignInViewModel>(() => SignInViewModel(repository: getIt(), authService: getIt(), tokenManager: getIt()));
  getIt.registerFactory<SignUpViewModel>(() => SignUpViewModel(repository: getIt(), authService: getIt(), tokenManager: getIt()));
  getIt.registerFactory<HomeViewModel>(() => HomeViewModel(authService: getIt(), apiClient: getIt()));
}
