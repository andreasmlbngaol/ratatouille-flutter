import 'package:flutter/foundation.dart';
import 'package:moprog/auth/data/auth/login_request/login_request.dart';
import 'package:moprog/auth/data/auth/login_response/login_response.dart';
import 'package:moprog/core/model/api_client.dart';

class RatatouilleRepository {
  final ApiClient apiClient;

  RatatouilleRepository({required this.apiClient});

  Future<LoginResponse?> login(LoginRequest request) async {
    try {
      final res = await apiClient.dio.post(
          "/auth/login",
          data: request.toJson()
      );
      debugPrint("Success login");
      return LoginResponse.fromJson(res.data as Map<String, dynamic>);
    } catch(e) {
      debugPrint("Catching error");
      return null;
    }
  }

  Future<bool?> checkEmailAvailability(String email) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/register/check-email",
        data: { "email": email }
      );

      if(res.statusCode! >= 200 && res.statusCode! < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Email already used");
      return null;
    }
  }

  Future<void> changeName(String name) async {
    try {
      await apiClient.dio.patch(
        "/users/me/name",
        data: { "name": name }
      );
    } catch (e) {
      debugPrint("Error changing name");
    }
  }
}