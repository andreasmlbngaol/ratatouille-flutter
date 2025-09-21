sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final bool isEmailVerified;
  const AuthSuccess({required this.isEmailVerified});
}

class AuthFailed extends AuthResult {
  final String message;
  const AuthFailed({required this.message});
}