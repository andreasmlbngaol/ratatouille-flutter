import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_state.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/utils/view_model.dart';

class SignUpViewModel extends ViewModel {
  final ApiClient apiClient;
  final AuthService authService;

  SignUpViewModel({required this.apiClient, required this.authService});

  SignUpState _state = const SignUpState();

  SignUpState get state => _state;

  void setEmail(String value) {
    _state = _state.copyWith(email: value);
    notifyListeners();
  }
  void setPassword(String value) {
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _state = _state.copyWith(confirmPassword: value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(passwordVisible: !_state.passwordVisible);
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _state =
        _state.copyWith(confirmPasswordVisible: !_state.confirmPasswordVisible);
    notifyListeners();
  }

  void signUp() async {
    print("Sign Up. Email: ${_state.email}, Password: ${_state.password}, Confirm Password: ${_state.confirmPassword}");
  }
}