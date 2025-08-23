import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class TokenManager {
  static const _boxName = "tokens";
  late Box _box;

  Future<void> init() async {
    debugPrint("TokenManager: initiating TokenManager");
    _box = await Hive.openBox(_boxName);
  }

  String? get accessToken => _box.get("access_token");
  String? get refreshToken => _box.get("refresh_token");

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    debugPrint("TokenManager: saving tokens...");
    await _box.put("access_token", accessToken);
    await _box.put("refresh_token", refreshToken);
  }

  Future<void> clearTokens() async {
    debugPrint("TokenManager: clearing tokens...");
    await _box.clear();
  }

}