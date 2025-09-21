import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moprog/auth/data/models/refresh_token_response/refresh_token_response.dart';
import 'package:moprog/auth/data/models/user/user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  factory LoginResponse({
    required RefreshTokenResponse tokens,
    required User user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}