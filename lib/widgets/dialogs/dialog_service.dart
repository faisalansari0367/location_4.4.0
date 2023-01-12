import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/dialogs/network_error_dialog.dart';
import 'package:bioplus/widgets/dialogs/status_dialog_new.dart';
import 'package:bioplus/widgets/dialogs/success.dart';
import 'package:flutter/material.dart';

class DialogService {
  static const _transitionDuration = Duration(milliseconds: 275);
  static const _curve = kCurve;

  static Future<T?> showDialog<T>({
    required Widget child,
  }) async {
    if (Get.isDialogOpen!) Get.back();

    final result = await Get.dialog(
      child,
      transitionCurve: _curve,
      transitionDuration: _transitionDuration,
    );
    return result;
  }

  static void failure({
    required NetworkExceptions error,
    void Function()? onCancel,
  }) {
    Get.dialog(
      NetworkErrorDialog(
        message: NetworkExceptions.getErrorMessage(error),
        onCancel: onCancel ?? Get.back,
      ),
      transitionCurve: _curve,
      transitionDuration: _transitionDuration,
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
      transitionDuration: _transitionDuration,
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
      transitionCurve: _curve,
      transitionDuration: _transitionDuration,
    );
  }
}
