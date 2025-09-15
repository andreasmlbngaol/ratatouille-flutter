import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moprog/core/presentation/splash/splash_view_model.dart';
import 'package:moprog/core/presentation/widget.dart';
import 'package:moprog/core/utils/launched_effect.dart';
import 'package:moprog/core/di/dependency_injection.dart';

class SplashScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ViewModelStatelessWidget(
      /// Ini contoh pemakaian dependency injection jadi gak perlu masukkan argumen SplashViewModel-nya
        viewModel: () => getIt<SplashViewModel>(),
        content: (context, viewModel) {

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
    );
  }
}