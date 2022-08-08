import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../animations/animated_button.dart';

class BottomNavbarItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? icon;
  final IconData? iconData;
  final bool isSelected;
  final Color? color;

  const BottomNavbarItem({
    Key? key,
    this.onTap,
    this.icon,
    required this.title,
    this.isSelected = false,
    this.iconData,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? (isSelected ? context.theme.primaryColor : Colors.grey.shade900);

    return AnimatedButton(
      onTap: onTap ?? () {},
      child: AnimatedContainer(
        padding: EdgeInsets.only(
          // bottom: 10.sp,
          left: 10.sp,
          right: 10.sp,
        ),
        duration: 300.milliseconds,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 14.h),
            SizedBox(
              height: 24.sp,
              child: _image(iconColor),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: 15.width,
              // height: 3.height,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: context.textTheme.subtitle2?.copyWith(
                  fontSize: 10.w,
                  color: iconColor,
                ),
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }

  Widget _image(Color iconColor) {
    return icon != null
        ? icon!.endsWith('.svg')
            ? SvgPicture.asset(
                icon!,
                fit: BoxFit.contain,
                color: iconColor,
              )
            : Image.asset(
                icon!,
                color: iconColor,
              )
        : Icon(
            iconData!,
            color: iconColor,
          );
  }
}
