import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_view_model.dart';
import 'package:moprog/core/presentation/widget.dart';
import 'package:moprog/core/di/dependency_injection.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToSignIn;

  const SignUpScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelStatelessWidget(
        viewModel: () => getIt<SignUpViewModel>(),
        content: (context, viewModel) {
          final state = viewModel.state;

          return Scaffold(
              body: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.key,
                          size: 64,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.abc),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)
                            )
                          ),
                          onChanged: (value) {
                            viewModel.setName(value);
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )
                          ),
                          onChanged: (value) {
                            viewModel.setEmail(value);
                          },
                        ),
                        TextField(
                          obscureText: !state.passwordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: viewModel.togglePasswordVisibility,
                                icon: Icon(state.passwordVisible ? Icons.visibility : Icons.visibility_off)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )
                          ),
                          onChanged: (value) {
                            viewModel.setPassword(value);
                          },
                        ),
                        TextField(
                          obscureText: !state.confirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: viewModel.toggleConfirmPasswordVisibility,
                                icon: Icon(state.confirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )
                          ),
                          onChanged: (value) {
                            viewModel.setConfirmPassword(value);
                          },
                        ),
                        FilledButton(
                            onPressed: () => viewModel.signUpWithEmailAndPassword(
                              onSuccess: onNavigateToHome,
                              onFailed: (error) {
                                Fluttertoast.showToast(
                                  msg: error,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            ),
                            child: const Text("Sign Up")
                        ),
                        ElevatedButton(
                            onPressed: () => viewModel.signInWithGoogle(
                              onSuccess: onNavigateToHome,
                              onFailed: (error) {
                                Fluttertoast.showToast(
                                  msg: error,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            ),
                            child: const Text("Sign In with Google")
                        ),
                        TextButton(
                            onPressed: onNavigateToSignIn,
                            child: const Text("Sudah punya akun? Masuk")
                        )
                      ]
                  ),
                ),
              )
          );
        }
    );
  }
}