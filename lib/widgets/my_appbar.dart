import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;
  final Color? backgroundColor;
  final Widget? title;
  // final Widget? leading;
  final VoidCallback? onBackPressed;

  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? iconColor;
  final bool showBackButton;

  const MyAppBar({
    this.actions = const [],
    this.title,
    this.elevation = 0.0,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.showBackButton = true,
    this.bottom,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // final drawer = Provider.of<MyDrawerController>(context, listen: false);
    final leadingArrow = IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
      onPressed: onBackPressed ?? () => Get.back(),
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.width),
        child: Column(
          children: [
            AppBar(
                // bottomOpacity: 0.5s,
                // foregroundColor: Colors.,
                // primary: true,
                backgroundColor: backgroundColor,
                leading: (showBackButton ? leadingArrow : SizedBox.shrink()),
                leadingWidth: showBackButton ? null : 0.0,
                actions: actions,
                title: title,
                elevation: elevation,
                bottom: bottom
                // ??
                // PreferredSize(
                //   child: Divider(
                //     indent: 5.width,
                //     endIndent: 5.width,
                //     // height: 1.height,
                //     thickness: 0.2.height,
                //   ),
                //   preferredSize: Size.fromHeight(0.2.height),
                // ),
                ),
            // Divider(
            //   height: 2,
            //   endIndent: 5.width,
            //   indent: 5.width,
            //   color: Color.fromARGB(91, 0, 0, 0),
            //   thickness: 1.w,
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
