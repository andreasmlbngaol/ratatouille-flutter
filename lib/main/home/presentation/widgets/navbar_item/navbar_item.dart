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
  NavbarItem(title: "Favs", selectedIcon: Icons.bookmark, unselectedIcon: Icons.bookmarks_outlined),
  NavbarItem(title: "My Secret", selectedIcon: Icons.receipt_long, unselectedIcon: Icons.receipt_long_outlined),
  NavbarItem(title: "Me", selectedIcon: Icons.person, unselectedIcon: Icons.person_outlined),
];