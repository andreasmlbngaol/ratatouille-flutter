import 'package:moprog/auth/data/repositories/auth_repository.dart';
import 'package:moprog/auth/domain/auth_result.dart';

class AuthHandler {
  final AuthRepository repository;

  AuthHandler({required this.repository});

  Future<void> signInWithGoogle({
    required Function() onSuccess,
    required Function(String) onFailed
  }) async {
    final result = await repository.signInWithGoogle();
    result is AuthFailed ? onFailed(result.message) : onSuccess();
  }
}