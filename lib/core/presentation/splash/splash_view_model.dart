
import 'package:flutter/cupertino.dart';
import 'package:moprog/core/model/api_client.dart';

class SplashViewModel extends ChangeNotifier {
  final ApiClient httpClient;

  SplashViewModel({required this.httpClient});

  void checkAuthUser({
    required Function() onAuthenticated,
    required Function() onUnauthenticated
  }) async {
    try {
      final res = await httpClient.dio.get("");
      debugPrint("SplashViewModel: ${res.data["message"]}");
      debugPrint("SplashViewModel: ${res.data["error"]}");
      debugPrint("SplashViewModel: ${res.data.toString()}");
      onAuthenticated();
    } catch (e) {
      debugPrint("SplashViewModel: ${e.toString()}");
      onUnauthenticated();
    }
  }
}