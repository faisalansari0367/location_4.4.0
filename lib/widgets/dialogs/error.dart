import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../my_elevated_button.dart';
import 'dialog_layout.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback onTap;

  const ErrorDialog({
    Key? key,
    required this.message,
    this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/error.json',
            height: 20.height,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.headline6,
            ),
          ),
          Gap(2.height),
          MyElevatedButton(
            text: buttonText ?? ('Continue'),
            width: 30.width,
            color: const Color.fromARGB(255, 255, 17, 0),
            padding: EdgeInsets.all(10.sp),
            onPressed: () async {
              onTap();
              // Get.back();
            },
          ),
          Gap(2.height),
        ],
      ),
    );
  }
}
