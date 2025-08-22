
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/utils/view_model.dart';

class SplashViewModel extends ViewModel {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  SplashViewModel({required this.apiClient, required this.tokenManager});

  void checkAuthUser({
    required Function() onAuthenticated,
    required Function() onUnauthenticated
  }) async {
    if (tokenManager.refreshToken != null) {
      print("User is authenticated");
      onAuthenticated();
    } else {
      print("User is not authenticated");
      onUnauthenticated();
    }
  }
}