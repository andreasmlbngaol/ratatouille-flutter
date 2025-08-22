import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moprog/core/presentation/theme.dart';
import 'package:moprog/core/di/dependency_injection.dart';
import 'package:moprog/router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // wajib sebelum buka box apapun
  await setupDi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
        title: 'MVVM Demo',
        theme: lightMaterialTheme,
        darkTheme: darkMaterialTheme,
    );
  }
}