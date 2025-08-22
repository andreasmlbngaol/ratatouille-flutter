import 'package:flutter/material.dart';

Future<T?> pushBackStack<T>(BuildContext context, Widget screen) {
  return Navigator.push<T>(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
                opacity: animation,
                child: child
            );
          }
      )
  );
}

Future<T?> resetBackStack<T>(BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
                opacity: animation,
                child: child
            );
          }
      )
  );
}