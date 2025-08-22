import 'package:flutter/material.dart';
import 'package:moprog/core/presentation/splash/splash_view_model.dart';
import 'package:moprog/core/presentation/widget.dart';
import 'package:moprog/core/utils/launched_effect.dart';
import 'package:moprog/core/di/dependency_injection.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToSignIn;

  const SplashScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelStatelessWidget(
        viewModel: () => getIt<SplashViewModel>(),
        content: (context, viewModel) {
          launchedEffect(() {
            viewModel.checkAuthUser(
                onAuthenticated: onNavigateToHome,
                onUnauthenticated: onNavigateToSignIn
            );
          });

          return Scaffold(
            body: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 32,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                        child: Image.asset(
                          "assets/images/logo.ico",
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                    ),
                  ],
                ),
              )
            ),
          );
        }
    );
  }
}