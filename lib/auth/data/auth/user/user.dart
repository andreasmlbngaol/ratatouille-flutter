// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moprog/auth/data/auth/auth_method.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({
    @JsonKey(name: "created_at") @Default("") String createdAt,
    @JsonKey(name: "email") @Default("") String email,
    @JsonKey(name: "id") @Default("") String id,
    @JsonKey(name: "is_email_verified") @Default(false) bool isEmailVerified,
    @JsonKey(name: "method") @Default(AuthMethod.EMAIL_AND_PASSWORD) AuthMethod method,
    @JsonKey(name: "name") @Default("") String name,
    @JsonKey(name: "profile_picture_url") @Default("") String profilePictureUrl,
    @JsonKey(name: "cover_picture_url") @Default("") String coverPictureUrl,
    @JsonKey(name: "bio") @Default("") String bio,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}