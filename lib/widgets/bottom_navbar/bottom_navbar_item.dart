import 'package:background_location/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: kBorderRadius,
        child: AnimatedContainer(
          width: 100.w,
          // margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: const EdgeInsets.only(
              // top: 10.sp,
              // left: 10.sp,
              // right: 10.sp,
              ),
          duration: 300.milliseconds,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(15.h),
              SizedBox(
                height: 24.sp,
                child: _image(iconColor),
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: context.textTheme.subtitle2?.copyWith(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
              // Spacer(),
              Gap(10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image(Color iconColor) {
    return icon != null
        ? icon!.endsWith('.svg')
            ? SvgPicture.asset(
                icon!,
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
