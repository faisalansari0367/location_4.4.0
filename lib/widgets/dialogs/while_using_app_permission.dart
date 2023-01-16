import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhileUsingAppPermission extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;

  const WhileUsingAppPermission({super.key, this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/map.png',
              height: 20.height,
            ),
            Gap(40.h),
            // Spacer(),
            Text(
              // '${Strings.appName} Needs location permission to confirm what location you are entering. Please allow location permission to use this service.',
              '${Strings.appName} Needs access to your location to confirm what Geofence you are entering. Please allow location permission to use this service.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.h,
              ),
            ),
            Gap(20.h),
            MyElevatedButton(
              text: 'Continue',
              onPressed: () async {
                if (onPressed != null) {
                  onPressed?.call();
                  return;
                }

                // final result = await GeolocatorService.openLocationSettings();
                // if (result) {
                //   Get.back();
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
