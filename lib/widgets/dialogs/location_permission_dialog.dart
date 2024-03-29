import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/maps/location_service/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  const LocationPermissionDialog({super.key, this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/precise_location.json',
              height: 40.height,
            ),
            Gap(40.h),
            // Spacer(),
            Text(
              // '${Strings.appName} Needs location permission to confirm what location you are entering. Please allow location permission to use this service.',
              '${Strings.appName} collects background location data when the user selects “Allow all the time” in the app request permission, to enable registered geofences Entry and Exit data to be collected even when the app is closed or not in use. This background feature will also be used for Imminent Danger alerts and SOS Emergency notifications.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.h,
              ),
            ),
            Gap(20.h),
            MyElevatedButton(
              text: buttonText ?? 'Open Settings',
              onPressed: () async {
                if (onPressed != null) {
                  onPressed?.call();
                  return;
                }

                final result = await GeolocatorService.openLocationSettings();
                if (result) {
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
