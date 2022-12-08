import 'package:bioplus/extensions/size_config.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../my_elevated_button.dart';

class NetworkErrorDialog extends StatelessWidget {
  final String message;
  final Widget? subtitle;
  final String buttonText;
  // final VoidCallback onRetry;
  final VoidCallback onCancel;

  const NetworkErrorDialog({
    Key? key,
    required this.message,
    required this.onCancel,
    this.subtitle,
    this.buttonText = 'Ok',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/network_error_light.json',
            frameRate: FrameRate.max,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.width),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyText1?.copyWith(
                color: Colors.grey[600],
                fontSize: 4.4.width,
              ),
            ),
          ),
          if (subtitle != null) Gap(1.height),
          if (subtitle != null) subtitle!,
          Gap(2.height),
          MyElevatedButton(
            text: buttonText,
            padding: EdgeInsets.all(10.sp),
            width: 35.width,
            color: Colors.red,
            onPressed: () async => onCancel(),
          ),
          Gap(2.height),
        ],
      ),
    );
  }
}
