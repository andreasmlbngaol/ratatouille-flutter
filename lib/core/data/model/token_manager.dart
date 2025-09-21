import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:moprog/auth/data/models/login_response/login_response.dart';
import 'package:moprog/auth/data/models/refresh_token_response/refresh_token_response.dart';
import 'package:moprog/auth/data/models/user/user.dart';

class TokenManager {
  static const _boxName = "auth_data";
  late Box _box;

  Future<void> init() async {
    debugPrint("TokenManager: initiating TokenManager");
    _box = await Hive.openBox(_boxName);
  }

  String? get accessToken => _box.get("access_token");
  String? get refreshToken => _box.get("refresh_token");

  User? get user => _getUser();

  User? _getUser() {
    final data = _box.get("user");
    if (data != null) {
      return User.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> saveTokens(RefreshTokenResponse tokens) async {
    debugPrint("TokenManager: saving tokens...");
    await _box.put("access_token", tokens.accessToken);
    await _box.put("refresh_token", tokens.refreshToken);
  }

  Future<void> _saveUser(User user) async {
    debugPrint("TokenManager: saving user...");
    await _box.put("user", user.toJson());
  }

  Future<void> saveData(LoginResponse data) async {
    await saveTokens(data.tokens);
    await _saveUser(data.user);
  }

  Future<void> clearTokens() async {
    debugPrint("TokenManager: clearing tokens...");
    await _box.clear();
  }

}