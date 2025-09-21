import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moprog/auth/data/models/login_request/login_request.dart';
import 'package:moprog/auth/data/models/login_response/login_response.dart';
import 'package:moprog/core/data/model/api_client.dart';

class BackendAuthService {
  final ApiClient apiClient;

  BackendAuthService({required this.apiClient});

  Future<LoginResponse?> login(LoginRequest request) async {
    try {
      final res = await apiClient.dio.post(
        "/auth/login",
        data: request.toJson()
      );
      debugPrint("Login success");
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

  // Untuk set name pas register
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

  Future<int> ping() async {
    try {
      final res = await apiClient.dio.get("/ping-protected");
      return res.statusCode!;
    } on DioException catch (e) {
      return e.response!.statusCode!;
    }
  }
}