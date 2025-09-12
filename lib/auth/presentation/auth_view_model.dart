import 'package:flutter/foundation.dart';
import 'package:moprog/auth/data/auth/auth_method.dart';
import 'package:moprog/auth/data/auth/login_request/login_request.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/auth/model/ratatouille_repository.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/utils/view_model.dart';

abstract class AuthViewModel extends ViewModel {
  final RatatouilleRepository repository;
  final AuthService authService;
  final TokenManager tokenManager;

  AuthViewModel({
    required this.repository,
    required this.authService,
    required this.tokenManager,
  });

  void signInWithGoogle({
    required Function() onSuccess,
    required Function(String) onFailed
  }) async {
    debugPrint("Sign In with Google");
    final credential = await authService.signInWithGoogle();
    final idToken = await credential?.user?.getIdToken();
    if (idToken != null) {
      final res = await repository.login(LoginRequest(idToken: idToken, method: AuthMethod.GOOGLE));
      if(res == null) {
        onFailed("Gagal. Silakan coba lagi.");
        authService.signOut();
        return;
      }
      await tokenManager.saveTokens(res.tokens.accessToken, res.tokens.refreshToken);
      onSuccess();
    }
  }
}