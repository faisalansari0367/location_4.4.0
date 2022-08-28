import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onTap;
  const SuccessDialog({Key? key, required this.onTap}) : super(key: key);

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
