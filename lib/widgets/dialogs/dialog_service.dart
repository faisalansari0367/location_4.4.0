import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:bioplus/widgets/dialogs/network_error_dialog.dart';
import 'package:bioplus/widgets/dialogs/status_dialog_new.dart';
import 'package:bioplus/widgets/dialogs/success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogService {
  static Future<T?> showDialog<T>({
    required Widget child,
  }) async {
    final result = await Get.dialog(
      child,
      transitionCurve: Curves.elasticOut,
      transitionDuration: const Duration(milliseconds: 400),
    );
    return result;
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
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static void error(String message) {
    Get.dialog(
      StatusDialog(
        message: message,
        lottieAsset: 'assets/animations/error.json',
        onContinue: Get.back,
      ),
      transitionCurve: Curves.elasticOut,
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static void success(
    String success, {
    required void Function() onCancel,
  }) {
    Get.dialog(
      SuccessDialog(
        onTap: () => onCancel(),
        message: success,
      ),
      transitionCurve: Curves.elasticOut,
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
