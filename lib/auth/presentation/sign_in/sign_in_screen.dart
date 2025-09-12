import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          final signInEnabled = state.email.isNotEmpty && state.password.isNotEmpty && state.emailError == null && state.passwordError == null;

          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // warna teks button
                ),
              ),
            ),
            child: Scaffold(
                body: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/auth_background.jpg"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.5), // angka 0.4 bisa diganti sesuai gelapnya
                            BlendMode.darken,
                          ),
                        )
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ===== "Rat" =====
                              Stack(
                                children: [
                                  // Outline kuning
                                  Text(
                                    "Rat",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 4
                                        ..color = Colors.orange,
                                    ),
                                  ),
                                  // Fill putih
                                  const Text(
                                    "Rat",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              // ===== "atouille" =====
                              Stack(
                                children: [
                                  // Outline putih
                                  Text(
                                    "atouille",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 4
                                        ..color = Colors.white,
                                    ),
                                  ),
                                  // Fill kuning
                                  const Text(
                                    "atouille",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: Divider(thickness: 2, color: Colors.white),
                              ),
                              const Text("Masuk Akun"),
                              Expanded(
                                child: Divider(thickness: 2, color: Colors.white),
                              ),
                            ],
                          ),
                          TextField(
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                errorText: state.emailError
                            ),
                            onChanged: (value) {
                              viewModel.setEmail(value);
                            },
                          ),
                          TextField(
                            obscureText: !state.passwordVisible,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: "Kata Sandi",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                    onPressed: viewModel.togglePasswordVisibility,
                                    icon: Icon(state.passwordVisible ? Icons.visibility : Icons.visibility_off)
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                errorText: state.passwordError
                            ),
                            onChanged: (value) {
                              viewModel.setPassword(value);
                            },
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: signInEnabled
                                      ? viewModel.signInWithEmailAndPassword
                                      : null,
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.yellow,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      minimumSize: Size(0, 44)
                                  ),
                                  child: const Text("Masuk")
                              )
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
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
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      minimumSize: Size(0, 44)
                                  ),
                                  icon: Image.asset(
                                    "assets/images/google_logo.png",
                                    width: 36,
                                    height: 36,
                                  ),
                                  label: const Text("Masuk dengan Google")
                              )
                          ),
                          TextButton(
                              onPressed: onNavigateToSignUp,
                              child: const Text("Belum punya akun? Daftar")
                          )
                        ]
                    ),
                  ),
                )
            ),
          );
        }
    );
  }
}