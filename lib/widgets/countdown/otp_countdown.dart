import 'package:bioplus/widgets/countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpCountDown extends StatelessWidget {
  final bool showCountdown;
  final VoidCallback? onTimeout, onRetry;

  const OtpCountDown({
    super.key,
    // this.isTimeout = false,
    // this.isRetrying = false,
    this.onTimeout,
    this.onRetry,
    this.showCountdown = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showCountdown)
          Text(
            'Request a new otp in ',
            style: context.textTheme.bodyText2?.copyWith(
              fontSize: 15.sp,
            ),
          ),
        // Gap(10.sp),
        CountDown(
          showCountdown: showCountdown,
          // isRetrying: isRetrying,
          // isTimeout: isTimeout,
          onTimeout: onTimeout,
          child: TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: context.theme.primaryColor,
            ),
            child: const Text('Resend otp'),
          ),
        )
      ],
    );
  }
}
