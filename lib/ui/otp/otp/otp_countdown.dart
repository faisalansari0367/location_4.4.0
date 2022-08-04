import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'countdown.dart';

class OtpCountDown extends StatelessWidget {
  final bool showCountdown;
  final VoidCallback? onTimeout, onRetry;

  const OtpCountDown({
    Key? key,
    // this.isTimeout = false,
    // this.isRetrying = false,
    this.onTimeout,
    this.onRetry,
    this.showCountdown = true,
  }) : super(key: key);

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
            child: Text('Resend otp'),
            style: TextButton.styleFrom(
              primary: context.theme.primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
