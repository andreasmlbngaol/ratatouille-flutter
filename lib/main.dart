import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moprog/core/data/di/getIt.dart';
import 'package:moprog/core/data/utils/theme.dart';
import 'package:moprog/router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  /// Inisialisasi Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Inisialisasi Hive untuk penyimpanan local jwt token nya
  await Hive.initFlutter();
  await setupDi();

  runApp(const ProviderScope(child : MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Pakai Material 3 Theme. see https://m3.material.io/
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: FToastBuilder(),
      routerConfig: router,
      title: 'MVVM Demo',
      theme: lightMaterialTheme,
      // darkTheme: darkMaterialTheme,
    );
  }
}