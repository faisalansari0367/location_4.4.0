import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NotifyManagerDialog extends StatelessWidget {
  final String? message;
  const NotifyManagerDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        padding: kPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16.w / 9.h,
              child: Lottie.asset('assets/animations/orange_alert.json'),
            ),
            Gap(20.h),
            Text(
              message ?? 'We have notified the property manager of your entry into the geofenced area',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 4.4.width,
                color: Colors.grey.shade600,
              ),
            ),
            Gap(20.h),
            MyElevatedButton(
              text: Strings.ok,
              // width: 100.w,
              width: 100.w,
              color: Colors.orange.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () async => Get.back(),
            ),
            // Gap(20.h),
          ],
        ),
      ),
    );
  }
}
