import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoSignatureFound extends StatelessWidget {
  final String message;
  final String? subtitle;
  final String buttonText;
  // final VoidCallback onRetry;
  final VoidCallback? onTap;
  const NoSignatureFound({
    super.key,
    required this.message,
    this.subtitle,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          children: [
            Lottie.asset(
              'assets/animations/signature.json',
              height: 200,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.width),
              child: Column(
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyText1?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 4.4.width,
                    ),
                  ),
                  Gap(1.height),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyText2?.copyWith(
                        // fontWeight
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            Gap(2.height),
            MyElevatedButton(
              text: buttonText,
              padding: EdgeInsets.all(10.sp),
              width: 35.width,
              color: Colors.red,
              onPressed: () async {
                if (onTap != null) onTap!();
                // if (onCancel == null) {
                //   // Get.to(() => CreateSignature(onDone: (s) {

                //   // }));
                // }
                // Get.back();
              },
            ),
            Gap(2.height),
          ],
        ),
      ),
    );
  }
}
