import 'package:flutter/cupertino.dart';
import 'package:moprog/auth/model/auth_service.dart';
import 'package:moprog/core/model/api_client.dart';
import 'package:moprog/core/utils/view_model.dart';

import 'home_state.dart';

class HomeViewModel extends ViewModel {
  final AuthService authService;
  final ApiClient apiClient;

  HomeViewModel({required this.authService, required this.apiClient});

  HomeState _state = const HomeState();

  HomeState get state => _state;

  void setSelectedIndex(int index) {
    _state = _state.copyWith(selectedIndex: index);
    notifyListeners();
  }

  void signOut(
      Function() onSuccess
  ) async {
    debugPrint("Sign Out");
    await authService.signOut();
    onSuccess();
  }

  void testPing() async {
    final resp = await apiClient.dio.get("/ping-protected");
    debugPrint(resp.statusCode.toString());
  }
}