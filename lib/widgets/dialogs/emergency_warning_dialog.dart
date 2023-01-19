import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyWarningDialog extends StatelessWidget {
  final String message;
  const EmergencyWarningDialog({super.key, this.message = ''});

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        padding: kPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency Warning',
              style: context.textTheme.headline6?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(15.h),
            Center(
              child: Image.asset(
                'assets/icons/warning_icon.png',
                height: 100,
              ),
            ),
            Gap(10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: const Color.fromARGB(255, 55, 55, 55),
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(25.h),
            MyElevatedButton(
              onPressed: () async {
                Get.back();
              },
              color: Colors.redAccent,
              width: 30.width,
              text: 'OK',
            ),
          ],
        ),
      ),
    );
  }
}
