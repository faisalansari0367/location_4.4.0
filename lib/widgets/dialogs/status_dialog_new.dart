import 'package:bioplus/extensions/size_config.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:bioplus/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class StatusDialog extends StatelessWidget {
  final String lottieAsset;
  final String message;
  final VoidCallback onContinue;
  const StatusDialog({
    super.key,
    required this.lottieAsset,
    required this.message,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(lottieAsset, height: 20.height),
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
            text: 'Continue',
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
