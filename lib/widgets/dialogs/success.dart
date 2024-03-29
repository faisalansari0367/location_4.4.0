import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onTap;
  final String? message;
  const SuccessDialog({super.key, required this.onTap, this.message});

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        padding: kPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/success.json'),
            Gap(20.h),
            Text(
              message ?? 'Success',
              textAlign: TextAlign.center,
              style: context.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(15.h),
            MyElevatedButton(
              text: 'Close',
              color: Colors.teal.shade300,
              onPressed: () async => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}
