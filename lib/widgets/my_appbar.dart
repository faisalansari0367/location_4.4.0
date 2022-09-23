import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/features/drawer/view/widgets/drawer_menu_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;
  final Color? backgroundColor;
  final Widget? title;
  final Widget? leading;
  final VoidCallback? onBackPressed;

  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? iconColor;
  final bool showBackButton, showDivider, centreTitle;

  const MyAppBar({
    this.actions = const [],
    this.title,
    this.elevation = 0.0,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.showBackButton = true,
    this.bottom,
    this.onBackPressed,
    this.leading,
    this.showDivider = false,
    this.centreTitle = false,
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
          // color: context.theme.primaryColor,
          elevation: elevation,
          iconTheme: IconThemeData(
            color: iconColor,
            // color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.w,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.width),
        child: Column(
          // mainAxisAlignment: Ma,
          children: [
            Flexible(
              child: AppBar(
                centerTitle: centreTitle,
                // bottomOpacity: 0.5s,
                // foregroundColor: Colors.,
                // primary: true,
                // backgroundColor: backgroundColor,
                // backgroundColor: Color.fromARGB(255, 85, 177, 106),
                // backgroundColor: Color(0xff3B4798),
                backgroundColor: Colors.white,
                leading: leading ?? (showBackButton ? leadingArrow : DrawerMenuIcon()),
                leadingWidth: showBackButton ? null : null,
                actions: actions,
                title: title,
                elevation: elevation,
                bottom: bottom,
              ),
            ),
            if (showDivider) _bottom(),
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

  Widget _bottom() {
    final divider = Container(
      // indent: 5.width,
      width: 90.width,
      // endIndent: 5.width,
      // height: 1.height,
      color: Colors.grey.shade300,
      height: 0.2.height,
    );

    return divider;
  }

  @override
  Size get preferredSize => Size.fromHeight(58.w);
}
