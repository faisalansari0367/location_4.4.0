import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../my_elevated_button.dart';

class NetworkErrorDialog extends StatelessWidget {
  final String message;
  final Widget? subtitle;
  // final VoidCallback onRetry;
  final VoidCallback onCancel;

  const NetworkErrorDialog({
    Key? key,
    required this.message,
    required this.onCancel,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(Assets.animations.networkError),
          Text(
            message,
            style: context.textTheme.headline6,
          ),
          if (subtitle != null) Gap(1.height),
          if (subtitle != null) subtitle!,
          Gap(2.height),
          MyElevatedButton(
            text: ('Close'),
            padding: EdgeInsets.all(10.sp),
            width: 30.width,
            onPressed: () async => onCancel(),
          ),
          Gap(2.height),
        ],
      ),
    );
  }
}
