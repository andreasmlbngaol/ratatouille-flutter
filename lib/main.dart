import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moprog/di/dependency_injection.dart';

import 'core/presentation/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // wajib sebelum buka box apapun
  await setupDi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark),
          useMaterial3: true
      ),
      title: 'MVVM Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true
      ),
      initialRoute: "/splash",
      routes: {
        "/splash": (_) => const SplashScreen(),
        "/authenticated": (_) => const AuthenticatedScreen(),
        "/unauthenticated": (_) => const UnauthenticatedScreen(),
      },
    );
  }
}

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authenticated Screen"),
      ),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}

class UnauthenticatedScreen extends StatelessWidget {
  const UnauthenticatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unauthenticated Screen"),
      ),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}
