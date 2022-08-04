import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;
  final Color? backgroundColor;
  final Widget? title;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? iconColor;
  final bool leadingIsArrowBack;

  const MyAppBar({
    this.actions = const [],
    this.title,
    this.elevation = 0.0,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.leadingIsArrowBack = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    // final drawer = Provider.of<MyDrawerController>(context, listen: false);
    final leadingArrow = IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
      onPressed: () => Get.back(),
    );
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          color: backgroundColor,
          elevation: elevation,
          iconTheme: IconThemeData(
            color: iconColor,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
          ),
        ),
      ),
      child: AppBar(
        // bottomOpacity: 0.5s,
        // foregroundColor: Colors.,
        // primary: true,
        backgroundColor: backgroundColor,
        leading: leadingIsArrowBack ? leadingArrow : null,
        actions: actions,
        title: title,
        elevation: elevation,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
