import 'package:flutter/material.dart';
import 'package:moprog/core/di/dependency_injection.dart';
import 'package:moprog/core/presentation/widget.dart';
import 'package:moprog/main/presentation/home/home_view_model.dart';
import 'package:moprog/main/presentation/home/navbar/navbar_item.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToSignIn;

  const HomeScreen({
    super.key,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelStatelessWidget(
        viewModel: () => getIt<HomeViewModel>(),
        content: (context, viewModel) {
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              selectedIndex: viewModel.state.selectedIndex,
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
                        onPressed: () { viewModel.signOut(onNavigateToSignIn); },
                        child: const Text("Sign Out")
                    ),
                    FilledButton(
                      onPressed: () { viewModel.testPing(); },
                      child: const Text("Ping"),
                    )
                  ],
                ),
              ),
            ][viewModel.state.selectedIndex]
          );
      }
    );
  }
}