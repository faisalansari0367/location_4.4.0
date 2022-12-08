import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BioSecureLogo extends StatelessWidget {
  const BioSecureLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gap(20.h),
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
