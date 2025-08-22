import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/core/utils/view_model.dart';

class HomeViewModel extends ViewModel {
  final AuthService authService;


  HomeViewModel({required this.authService});

  void signOut(
      Function() onSuccess
  ) async {
    print("Sign Out");
    await authService.signOut();
    onSuccess();
  }
}