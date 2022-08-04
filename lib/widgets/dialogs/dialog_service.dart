import 'package:background_location/widgets/dialogs/network_error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DialogService {
  static void showDialog({
    required Widget child,
  }) {
    Get.dialog(
      child,
      transitionCurve: Curves.elasticOut,
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  static void failure({
    required error,
  }) {
    Get.dialog(
      NetworkErrorDialog(
        message: 'Something Went Wrong',
        onCancel: Get.back,
      ),
      transitionCurve: Curves.elasticOut,
      transitionDuration: Duration(milliseconds: 400),
    );
  }
}
