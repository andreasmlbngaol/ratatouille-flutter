import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelStatelessWidget<T extends ChangeNotifier> extends StatelessWidget {
  final T Function() viewModel;
  final Widget Function(BuildContext context, T viewModel) content;

  const ViewModelStatelessWidget({
    super.key,
    required this.viewModel,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => viewModel(),
      child: Consumer<T>(
        builder: (context, vm, _) => content(context, vm),
      ),
    );
  }
}