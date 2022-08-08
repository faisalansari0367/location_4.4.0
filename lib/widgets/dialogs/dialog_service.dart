import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:background_location/constants/constans.dart';
import 'package:background_location/widgets/dialogs/network_error_dialog.dart';
import 'package:flutter/material.dart';
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
    void Function()? onCancel,
  }) {
    Get.dialog(
      NetworkErrorDialog(
        message: NetworkExceptions.getErrorMessage(error),
        onCancel: onCancel ?? Get.back,
      ),
      transitionCurve: Curves.elasticOut,
      transitionDuration: Duration(milliseconds: 400),
    );
  }
}
