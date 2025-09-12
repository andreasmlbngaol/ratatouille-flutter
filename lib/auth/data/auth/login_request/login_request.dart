// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moprog/auth/data/auth/auth_method.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
abstract class LoginRequest with _$LoginRequest {
  factory LoginRequest({
    @JsonKey(name: 'id_token') required String idToken,
    required AuthMethod method,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}