import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/BIO_shield1 (1).png',
          height: 7.height,
        ),
        Text(
          'BIO',
          style: TextStyle(
            color: const Color(0xff3B4798),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
        Text(
          'PLUS',
          style: TextStyle(
            color: const Color(0xff75B950),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
      ],
    );
  }
}
