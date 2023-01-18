import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/maps/location_service/geolocator_service.dart';
import 'package:bioplus/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/error.dart';
import 'package:bioplus/widgets/dialogs/location_permission_dialog.dart';
import 'package:bioplus/widgets/dialogs/while_using_app_permission.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final VoidCallback onDenied;
  final VoidCallback onGranted;

  PermissionService(this.onDenied, this.onGranted);

  // final isLimitedPermission = await Permission.location.isLimited;
  // if (isLimitedPermission) {
  //   BottomSheetService.showSheet(
  //     child: LocationPermissionDialog(
  //       onPressed: () => Permission.location.request(),
  //     ),
  //   );
  // }

  Future<void> handlePermission() async {
    final isPermissionGranted = await Permission.location.isGranted;
    // print(await Permission.location.isLimited);
    // print(await Permission.location.isDenied);
    // print(await Permission.location.isRestricted);
    // print(Permission.location.isBlank);

    if (!isPermissionGranted) {
      // final status = await Permission.location.request();
      // if (status.isGranted) {
      //   // Get.back();
      //   _allowAllTheTime();
      // }
      BottomSheetService.showSheet(
        child: WhileUsingAppPermission(
          buttonText: 'Ask Permission',
          onPressed: () async {
            final status = await Permission.locationWhenInUse.request();
            // final status = await GeolocatorService.locationPermission();

            if (status.isGranted) {
              Get.back();
              _allowAllTheTime();
              return;
            }

            if (status.isPermanentlyDenied) {
              Get.back();
              _permissionDenied();
              return;
            }

            if (!status.isGranted) {
              Get.back();
              _permissionDenied();
              return;
            }
          },
        ),
      );
    } else if (await Permission.location.isPermanentlyDenied) {
      _permissionDenied();
    } else if (await Permission.location.isDenied) {
      _permissionDenied();
    } else {
      _allowAllTheTime();
    }
  }

  void _permissionDenied() {
    DialogService.showDialog(
      child: ErrorDialog(
        message:
            'You have denied the location permission therefore we regret to inform you that we cannot proceed further\n\nPlease go to app settings and allow the permission to use this app',
        onTap: () {
          // Get.back();
          GeolocatorService.openLocationSettings();
          onDenied.call();
          // // Get.reset();
          // api.logout();
          // Get.offAll(() => const LoginPage());
        },
      ),
    );
  }

  Future<void> _allowAllTheTime() async {
    final result = await Permission.location.status;
    // final result = await GeolocatorService.locationPermission();
    if (result.isGranted) {
      final isGranted = (await Permission.locationAlways.status).isGranted;
      // final isNotGranted = PermissionStatus.granted != status;
      if (!isGranted) {
        BottomSheetService.showSheet(
          child: LocationPermissionDialog(
            onPressed: () async {
              // Permission.location.
              final result = await Permission.locationAlways.request();
              if (result.isGranted) {
                Get.back();
                onGranted.call();
                // await cubit.init();
              } else {
                Get.back();
                _permissionDenied();
              }
            },
          ),
        );
      } else {
        // await cubit.init();
        onGranted.call();
      }
    } else {
      // await cubit.init();
      // await 3.seconds.delay();
      // await DialogService.showDialog(child: const LocationPermissionDialog());
    }
  }
}
