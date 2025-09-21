import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/auth/data/repositories/auth_repository.dart';
import 'package:moprog/auth/domain/check_auth_status.dart';

class SplashViewModel extends StateNotifier {
  final AuthRepository _repository;

  SplashViewModel({required AuthRepository repository})
      : _repository = repository,
        super(null);

  void checkAuthUser({
    required Function() onAuthenticated,

    /// Callback function sebutannya
    required Function() onNavigateToVerification,
    required Function() onUnauthenticated,
    required Function() onNoInternetConnection,
    required Function() onServerError
  }) async {
    final status = await _repository.checkAuthStatus();
    switch (status) {
      case CheckAuthStatus.authenticated:
        onAuthenticated();
        break;
      case CheckAuthStatus.unauthenticated:
        onUnauthenticated();
        break;
      case CheckAuthStatus.noInternet:
        onNoInternetConnection();
        break;
      case CheckAuthStatus.serverError:
        onServerError;
        break;
      case CheckAuthStatus.needVerification:
        onNavigateToVerification();
        break;
    }
  }
}