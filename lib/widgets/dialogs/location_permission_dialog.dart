import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/maps/location_service/geolocator_service.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        padding: kPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/precise_location.json',
            ),
            Gap(40.h),
            // Spacer(),
            Text(
              'Please allow location permission to use this service.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.h,
              ),
            ),
            Gap(20.h),
            MyElevatedButton(
              text: 'Open Settings',
              onPressed: () async {
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
