import 'package:go_router/go_router.dart';
import 'package:moprog/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:moprog/core/utils/navigator.dart';
import 'package:moprog/auth/presentation/sign_up/sign_up_screen.dart';
import 'package:moprog/core/presentation/splash/splash_screen.dart';
import 'package:moprog/main/presentation/home/home_screen.dart';

/// Navigasi dari mana ke mana langsung diatur dari sini, biar terpusat dan gampang debug nya
final router = GoRouter(
  initialLocation: "/splash",

  routes: [

    route(
      path: "/splash",
      child: (navController) => SplashScreen(
        onNavigateToHome: () => navController.go("/home"),
        onNavigateToVerification: () => navController.go("/sign_up"), // Ini nanti diganti sama route untuk email verification
        onNavigateToSignIn: () => navController.go("/sign_in")
      )
    ),

    route(
      path: "/sign_in",
      child: (navController) => SignInScreen(
        onNavigateToHome: () => navController.go("/home"),
        onNavigateToVerification: () => navController.go("/sign_up"), // Ini nanti diganti sama route untuk email verification
        onNavigateToSignUp: () => navController.go("/sign_up")
      )
    ),

    route(
        path: "/sign_up",
        child: (navController) => SignUpScreen(
          onNavigateToHome: () => navController.go("/home"),
          onNavigateToVerification: () => navController.go("/sign_up"), // Ini nanti diganti sama route untuk email verification
          onNavigateToSignIn: () => navController.go("/sign_in")
        )
    ),

    route(
        path: "/home",
        child: (navController) => HomeScreen(
          onNavigateToSignIn: () => navController.go("/sign_in"),
        )
    ),


  ]
);