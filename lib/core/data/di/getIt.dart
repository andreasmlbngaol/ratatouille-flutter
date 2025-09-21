import 'package:get_it/get_it.dart';
import 'package:moprog/auth/data/repositories/auth_repository.dart';
import 'package:moprog/auth/data/services/backend_auth_service.dart';
import 'package:moprog/auth/data/services/firebase_auth_service.dart';
import 'package:moprog/core/data/model/api_client.dart';
import 'package:moprog/core/data/model/token_manager.dart';

/// Ini objek dari dependency injector nya
final getIt = GetIt.instance;

Future<void> setupDi() async {
  /// Panggil di dalam SplashViewModel biar gak kelamaan startup nya
  // await tokenManager.init();

  /// Singleton object biar gampang inject di semua ViewModel
  getIt.registerLazySingleton<TokenManager>(() => TokenManager());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(tokenManager: getIt()));
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<BackendAuthService>(() => BackendAuthService(apiClient: getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository.create(getIt));
}
