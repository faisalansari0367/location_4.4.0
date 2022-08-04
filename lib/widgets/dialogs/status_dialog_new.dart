import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../my_elevated_button.dart';

class StatusDialog extends StatelessWidget {
  final String lottieAsset;
  final String message;
  final VoidCallback onContinue;
  const StatusDialog({
    Key? key,
    required this.lottieAsset,
    required this.message,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(lottieAsset),
          Text(
            message,
            style: context.textTheme.headline6,
          ),
          Gap(2.height),
          MyElevatedButton(
            text: ('Continue'),
            width: 30.width,
            padding: EdgeInsets.all(10.sp),
            onPressed: () async {
              onContinue();
              // Get.back();
            },
          ),
          Gap(2.height),
        ],
      ),
    );
  }
}
