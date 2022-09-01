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


//  return const [
//          GButton(icon: LineIcons.alternateCreativeCommonsPublicDomain, text: 'Dashba'),
//       GButton(icon: LineIcons.alternateCreativeCommonsPublicDomain, text: 'Admin'),
//       GButton(icon: LineIcons.userAlt, text: 'Select Role'),
//       GButton(icon: LineIcons.map, text: 'Maps'),
//       GButton(icon: LineIcons.userCog, text: 'Settings'),
//     ];