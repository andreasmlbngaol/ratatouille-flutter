import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default("") String name,
    @Default(null) String? nameError,
    @Default("") String email,
    @Default(null) String? emailError,
    @Default("") String password,
    @Default(null) String? passwordError,
    @Default("") String confirmPassword,
    @Default(null) String? confirmPasswordError,
    @Default(false) bool passwordVisible,
    @Default(false) bool confirmPasswordVisible,
  }) = _SignUpState;
}