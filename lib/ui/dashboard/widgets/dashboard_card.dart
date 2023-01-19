import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/widgets/animations/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;
  final IconData? iconData;
  final Color? imagecolor;
  final String? image;
  final double? size;
  const DashboardCard({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.iconData,
    this.onTap,
    this.image,
    this.imagecolor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // const color = Color.fromARGB(255, 255, 255, 255);
    // const _color = kPrimaryColor;
    // final size = MediaQuery.of(context).size;
    // final imageSize = size ?? _size.height * 0.05;
    final imageSize = size ?? 40.w;
    return AnimatedButton(
      onTap: () => onTap?.call(),
      child: Container(
        decoration: BoxDecoration(
          // boxShadow: kBoxShadow,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                image!,
                // height: 40,
                // width: 40,
                height: imageSize,
                width: imageSize,
                // color: _color,
                // color: imagecolor ?? Colors.black.withOpacity(0.7),
              )
            else
              Icon(
                iconData,
                // size: 40,
                size: imageSize,
                // color: _color,

                // color: Colors.black.withOpacity(0.7),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: 120.w,
              child: AutoSizeText(
                text,
                textAlign: TextAlign.center,
                maxLines: text.split(' ').length > 1 ? 2 : 1,
                style: ThemeData.light().textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Colors.grey.shade900,
                      // color: _color,

                      fontSize: 16.w,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
