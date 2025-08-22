import 'package:flutter/material.dart';

final darkMaterialTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
    useMaterial3: true
);

final lightMaterialTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true
);