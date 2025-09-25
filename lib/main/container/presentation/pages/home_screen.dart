import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moprog/main/container/presentation/widgets/navbar_item/navbar_item.dart';
import 'package:moprog/provider.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onNavigateToSignIn;

  const HomeScreen({
    super.key,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final viewModel = ref.read(homeProvider.notifier);

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: state.selectedIndex,
          onDestinationSelected: (index) {
            viewModel.setSelectedIndex(index);
          },
          destinations: navbarItems.map((item) {
            return NavigationDestination(
              icon: Icon(item.unselectedIcon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.title,
            );
          }).toList(),
        ),
        body: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Home Screen"),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Favs Screen"),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("My Secret Screen"),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Me Screen"),
                FilledButton(
                    onPressed: () {
                      viewModel.signOut(onNavigateToSignIn);
                    },
                    child: const Text("Sign Out")
                ),
                FilledButton(
                  onPressed: () {
                    viewModel.testPing();
                  },
                  child: const Text("Ping"),
                )
              ],
            ),
          ),
        ][state.selectedIndex]
    );
  }
}
