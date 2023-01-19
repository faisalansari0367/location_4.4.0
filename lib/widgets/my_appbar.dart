import 'package:bioplus/features/drawer/view/widgets/drawer_menu_icon.dart';
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
    final color =
        (backgroundColor ?? context.theme.backgroundColor).computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final leadingArrow = IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        // color: Colors.black,
        color: color,
      ),
      onPressed: onBackPressed ?? Get.back,
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
            // color: Colors.black,
            color: color,
            fontSize: 20,
          ),
        ),
      ),
      child: AppBar(
        centerTitle: centreTitle,
        // bottomOpacity: 0.5s,
        // foregroundColor: Colors.,
        // primary: true,
        // backgroundColor: backgroundColor,
        // backgroundColor: Color.fromARGB(255, 85, 177, 106),
        // backgroundColor: Color(0xff3B4798),
        backgroundColor: backgroundColor ?? Colors.white,
        leading: leading ?? (showBackButton ? leadingArrow : const DrawerMenuIcon()),
        leadingWidth: showBackButton ? null : null,
        actions: actions,
        title: title,
        elevation: elevation,
        bottom: bottom ?? _bottom(),
      ),
    );
    // child: Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 0.width),
    //   child: Column(
    //     // mainAxisAlignment: Ma,
    //     children: [
    //       Flexible(
    //         child: AppBar(
    //           centerTitle: centreTitle,
    //           // bottomOpacity: 0.5s,
    //           // foregroundColor: Colors.,
    //           // primary: true,
    //           // backgroundColor: backgroundColor,
    //           // backgroundColor: Color.fromARGB(255, 85, 177, 106),
    //           // backgroundColor: Color(0xff3B4798),
    //           backgroundColor: Colors.white,
    //           leading: leading ?? (showBackButton ? leadingArrow : const DrawerMenuIcon()),
    //           leadingWidth: showBackButton ? null : null,
    //           actions: actions,
    //           title: title,
    //           elevation: elevation,
    //           bottom: bottom,
    //         ),
    //       ),
    //       if (showDivider) _bottom(),
    //       // Divider(
    //       //   height: 2,
    //       //   endIndent: 5.width,
    //       //   indent: 5.width,
    //       //   color: Color.fromARGB(91, 0, 0, 0),
    //       //   thickness: 1.w,
    //       // ),
    //     ],
    //   ),
    // ),
    // );
  }

  PreferredSizeWidget _bottom() {
    return showDivider
        ? PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              color: Colors.grey.withOpacity(0.2),
              height: 1.0,
            ),
          )
        : const PreferredSize(preferredSize: Size.fromHeight(0), child: SizedBox());
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
