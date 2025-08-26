import 'package:flutter/material.dart';
import 'package:moprog/core/di/dependency_injection.dart';
import 'package:moprog/core/presentation/widget.dart';
import 'package:moprog/main/presentation/home/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToSignIn;

  const HomeScreen({
    super.key,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelStatelessWidget(
        viewModel: () => getIt<HomeViewModel>(),
        content: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Home Screen"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Home Screen"),
                  FilledButton(
                      onPressed: () { viewModel.signOut(onNavigateToSignIn); },
                      child: const Text("Sign Out")
                  ),
                  FilledButton(
                    onPressed: () { viewModel.testPing(); },
                    child: const Text("Ping"),
                  )
                ],
              ),
            ),
          );
      }
    );
  }
}