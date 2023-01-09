import 'package:flutter/cupertino.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateService {
  Future<AppUpdateInfo?> checkUpdate() async {
    try {
      final result = await InAppUpdate.checkForUpdate();
      await InAppUpdate.performImmediateUpdate();
      return result;
    } catch (e) {
      debugPrint('failed to update');
    }
    return null;
  }
}
