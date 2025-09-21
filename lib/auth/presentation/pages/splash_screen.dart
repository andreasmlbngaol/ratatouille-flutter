import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moprog/core/data/utils/launched_effect.dart';
import 'package:moprog/provider.dart';

class SplashScreen extends ConsumerWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToVerification;
  final VoidCallback onNavigateToSignIn;

  const SplashScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToVerification,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(splashProvider.notifier);

    /// Ini dijalankan pas UI nya siap di render. Jadi render selesai, baru cek apakah user sudah login atau belum
    launchedEffect(() {
      viewModel.checkAuthUser(
          onAuthenticated: onNavigateToHome,
          onNoInternetConnection: () {
            Fluttertoast.showToast(
              msg: "No Internet Connection",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          },
          onNavigateToVerification: onNavigateToVerification,
          onUnauthenticated: onNavigateToSignIn,
          onServerError: () {
            Fluttertoast.showToast(
              msg: "Server Error",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
      );
    });

    /// Ini UI nya :v
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
}
