import 'package:flutter/material.dart';
import 'package:moprog/auth/presentation/sign_in/sign_in_view_model.dart';
import 'package:moprog/core/di/dependency_injection.dart';
import 'package:moprog/core/presentation/widget.dart';

class SignInScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToSignUp;

  const SignInScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelStatelessWidget(
        viewModel: () => getIt<SignInViewModel>(),
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
                          "Sign In",
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
                        ElevatedButton(
                            onPressed: () => viewModel.signInWithGoogle(onSuccess: onNavigateToHome),
                            child: const Text("Sign In with Google")
                        ),
                        FilledButton(
                            onPressed: state.email.isNotEmpty && state.password.isNotEmpty ? viewModel.signInWithEmailAndPassword : null,
                            child: const Text("Sign In")
                        ),
                        TextButton(
                            onPressed: onNavigateToSignUp,
                            child: const Text("Belum punya akun? Daftar")
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