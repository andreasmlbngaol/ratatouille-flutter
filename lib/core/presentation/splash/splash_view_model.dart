
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/utils/view_model.dart';

/// Ini sebenarnya pakai ChangeNotifier bukan ViewModel nama aslinya
class SplashViewModel extends ViewModel {
  final AuthService authService;
  final ApiClient apiClient;
  final TokenManager tokenManager;

  SplashViewModel({required this.apiClient, required this.tokenManager, required this.authService});

  void checkAuthUser({
    required Function() onAuthenticated, /// Callback function sebutannya
    required Function() onUnauthenticated
  }) async {
    await tokenManager.init(); /// Ini yang harusnya ada di dependency_injection, biar gak kelamaan startup disini aja

    if (tokenManager.refreshToken != null && tokenManager.accessToken != null) {
      debugPrint("checkAuthUser: Refresh Token and Access Token found");
      try {
        final res = await apiClient.dio.get("/ping-protected");

        if (res.statusCode == 200) {
          debugPrint("checkAuthUser: /ping-protected success");
          onAuthenticated();
          return;
        }
      } on DioException catch (_) {
        debugPrint("Access Token and Refresh Token invalid");
        await authService.signOut();
        onUnauthenticated();
        return;
      }
    }

    debugPrint("checkAuthUser: Refresh Token and Access Token not found");
    await authService.signOut();
    onUnauthenticated();
  }
}