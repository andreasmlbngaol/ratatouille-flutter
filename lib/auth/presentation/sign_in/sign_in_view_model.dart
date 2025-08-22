import 'package:dio/dio.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/auth/presentation/sign_in/sign_in_state.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/model/token_manager.dart';
import 'package:moprog/core/utils/view_model.dart';

class SignInViewModel extends ViewModel {
  final ApiClient apiClient;
  final AuthService authService;
  final TokenManager tokenManager;

  SignInViewModel({
    required this.apiClient,
    required this.authService,
    required this.tokenManager
  });

  SignInState _state = const SignInState();

  SignInState get state => _state;

  void setEmail(String value) {
    _state = _state.copyWith(email: value);
    notifyListeners();
  }
  void setPassword(String value) {
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(passwordVisible: !_state.passwordVisible);
    notifyListeners();
  }

  void signIn() async {
    print("Sign In. Email: ${_state.email}, Password: ${_state.password}");
  }

  void signInWithGoogle({
    required Function() onSuccess
  }) async {
    print("Sign In with Google");
    final credential = await authService.signInWithGoogle();
    final idToken = await credential?.user?.getIdToken();
    if (idToken != null) {
      final res = await signInToBackEnd(idToken: idToken, method: "GOOGLE");
      if(res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        onSuccess();
      }
    }
  }

  Future<Response> signInToBackEnd({
    required String idToken,
    required String method
  }) async {
    print("Sign In to Back End");
    final res = await apiClient.dio.post(
      "/auth/login",
      data: {
        "id_token": idToken,
        "method": method
      }
    );

    print(res.data);

    final tokens = res.data["tokens"];

    final accessToken = tokens["access_token"];
    final refreshToken = tokens["refresh_token"];

    await tokenManager.saveTokens(accessToken, refreshToken);

    return res;
  }
}