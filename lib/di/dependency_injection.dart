import 'package:get_it/get_it.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/presentation/splash/splash_view_model.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  final tokenManager = TokenManager();
  await tokenManager.init();

  // Singleton
  getIt.registerSingleton<TokenManager>(tokenManager);
  getIt.registerSingleton<ApiClient>(ApiClient(tokenManager: getIt()));

  // VM Factory
  getIt.registerFactory<SplashViewModel>(() => SplashViewModel(httpClient: getIt()));
}
