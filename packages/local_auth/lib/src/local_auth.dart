import 'dart:async';

import 'package:local_auth/local_auth.dart';

class LocalAuth {
  // final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  //   final bool canAuthenticate =
  //       canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  //       final List<BiometricType> availableBiometrics =
  //   await auth.getAvailableBiometrics();
  late LocalAuthentication _localAuth;
  List<BiometricType> availableBiometrics = [];
  bool isSupported = false;
  final _isInstantiated = Completer<void>();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  LocalAuth() {
    _init();
  }

  void _init() async {
    _localAuth = LocalAuthentication();
    availableBiometrics = await _localAuth.getAvailableBiometrics();
    isSupported = await _localAuth.isDeviceSupported();
    _isInstantiated.complete();
  }

  Future<bool> authenticate() async {
    try {
      await _isInstantiated.future;
      if (!isSupported) return false;
      final result = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
      );
      _isAuthenticated = result;
      return result;
    } on Exception {
      return false;
    }
  }
}
