
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default("") String email,
    @Default("") String password,
    @Default("") String confirmPassword,
    @Default(false) bool passwordVisible,
    @Default(false) bool confirmPasswordVisible,
  }) = _SignUpState;
}