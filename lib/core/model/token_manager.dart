import 'package:hive/hive.dart';

class TokenManager {
  static const _boxName = "tokens";
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  String? get accessToken => _box.get("access_token");
  String? get refreshToken => _box.get("refresh_token");

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _box.put("access_token", accessToken);
    await _box.put("refresh_token", refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _box.put("access_token", accessToken);
  }

  Future<void> removeTokens() async {
    await _box.clear();
  }

}