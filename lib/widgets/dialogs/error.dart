// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bioplus/extensions/size_config.dart';
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
  final bool showCloseButton;

  const ErrorDialog({
    Key? key,
    required this.message,
    this.buttonText,
    required this.onTap,
    this.showCloseButton = true,
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
          if (showCloseButton) ...[
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
        ],
      ),
    );
  }
}
