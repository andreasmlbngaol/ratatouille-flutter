
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navbar_item.freezed.dart';

@freezed
abstract class NavbarItem with _$NavbarItem {
  const factory NavbarItem({
    required String title,
    required IconData selectedIcon,
    required IconData unselectedIcon
  }) = _NavbarItem;
}

final navbarItems = [
  NavbarItem(title: "Home", selectedIcon: Icons.home_filled, unselectedIcon: Icons.home_outlined),
  NavbarItem(title: "Settings", selectedIcon: Icons.settings, unselectedIcon: Icons.settings_outlined),
  NavbarItem(title: "Profile", selectedIcon: Icons.person, unselectedIcon: Icons.person_outlined),
];