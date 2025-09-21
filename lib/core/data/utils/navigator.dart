import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRoute route({
  required String path,
  required Widget Function(BuildContext) child,
}) => GoRoute(
  path: path,
  pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
  ),
);