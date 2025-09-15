
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
    required Function() onNavigateToVerification,
    required Function() onUnauthenticated,
    required Function() onNoInternetConnection,
    required Function() onServerError
  }) async {
    await tokenManager.init(); /// Ini yang harusnya ada di dependency_injection, biar gak kelamaan startup disini aja

    // Step 1: Cek koneksi internet
    final hasInternet = await InternetConnectionChecker.instance.hasConnection;
    if(!hasInternet) {
      debugPrint("checkAuthUser: No Internet Connection");
      onNoInternetConnection();
      return;
    }

    // Step 2: Cek apakah user sudah login atau belum
    if (tokenManager.refreshToken != null && tokenManager.accessToken != null) {
      debugPrint("checkAuthUser: Refresh Token and Access Token found");
      try {
        final res = await apiClient.dio.get("/ping-protected");

        if (res.statusCode == 200) {
          debugPrint("checkAuthUser: /ping-protected success");
          onAuthenticated();
          if(tokenManager.user?.isEmailVerified == true) {
            onAuthenticated();
          } else {
            onNavigateToVerification();
          }
          return;
        }
      } on DioException catch (e) {
        if(e.response?.statusCode != null && e.response!.statusCode! > 500) {
          debugPrint("checkAuthUser: Server Error");
          onServerError();
          return;
        }
        debugPrint("Access Token and Refresh Token invalid");
        await authService.signOut();
        onUnauthenticated();
        return;
      }
    }

    // Step 3: Jika tidak ada refresh token atau access token, langsung sign out
    debugPrint("checkAuthUser: Refresh Token and Access Token not found");
    await authService.signOut();
    onUnauthenticated();
  }
}