import 'package:flutter/widgets.dart';

void launchedEffect(Function() onRendered) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    onRendered();
  });
}
