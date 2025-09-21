import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/auth/data/repositories/auth_repository.dart';
import 'package:moprog/core/data/model/api_client.dart';
import 'package:moprog/main/home/presentation/state/home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final AuthRepository _authRepository;
  final ApiClient _apiClient;

  HomeViewModel({required AuthRepository authRepository, required ApiClient apiClient})
      : _authRepository = authRepository,
        _apiClient = apiClient,
        super(const HomeState());

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void signOut(
      Function() onSuccess
      ) async {
    debugPrint("Sign Out");
    _authRepository.signOut();
    onSuccess();
  }

  void testPing() async {
    final resp = await _apiClient.dio.get("/ping-protected");
    debugPrint(resp.statusCode.toString());
  }
}