import 'package:flutter/material.dart';

class DrawerItem {
  final String text;
  final IconData iconData;
  final Widget page;
  final Color? color;
  final String? image;
  final VoidCallback? onTap;

  const DrawerItem({
    this.onTap,
    this.image,
    this.color,
    required this.page,
    required this.text,
    required this.iconData,
  });
}
