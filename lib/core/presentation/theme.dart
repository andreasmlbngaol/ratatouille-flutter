import 'package:flutter/material.dart';

final darkMaterialTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
    useMaterial3: true
);

final lightMaterialTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    useMaterial3: true
);