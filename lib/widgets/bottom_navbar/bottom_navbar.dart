import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'bottom_navbar_item.dart';

class BottomNavbar extends StatefulWidget {
  final Color color;
  final List<BottomNavbarItem> items;
  const BottomNavbar({Key? key, required this.items, this.color = Colors.white}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(bottom: padding),
      decoration: BoxDecoration(
        color: widget.color,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 10,
        //     spreadRadius: 5,
        //   )
        // ],
        // borderRadius: BorderRadius.vertical(
        //   top: kBorderRadius.topRight,
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items,
      ),
      // borderRadius: kBorderRadius,
    );
  }

  double get padding {
    // final _kHeight = 60.sp;
    final padding = MediaQuery.of(context).viewPadding.bottom;
    final bottomPadding = Platform.isIOS ? min(padding, 15.sp) : padding;
    return bottomPadding.toDouble();
  }
}
