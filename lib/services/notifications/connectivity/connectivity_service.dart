import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:background_location/constants/index.dart';
import 'package:background_location/helpers/callback_debouncer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';

class MyConnectivity {
  static late StreamSubscription<ConnectivityResult> _subscription;
  static final _controller = BehaviorSubject<bool>.seeded(true);
  static bool _isInited = false;
  static var _first = true;
  static bool isConnected = true;

  Stream<bool> get connectionStream {
    // _checkConnectivity();
    return _controller.stream;
  }

  MyConnectivity() {
    if (_isInited) return;
    initConnectivity();
  }

  static void cancel() {
    _subscription.cancel();
  }

  void initConnectivity() async {
    _isInited = true;
    _subscription = Connectivity().onConnectivityChanged.listen(listener);
    await _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _controller.add(true);
        _show(
          title: 'Internet found',
          msg: 'You can use our services in normal mode',
          bgColor: Colors.green,
          state: true,
        );
      }
    } on SocketException catch (_) {
      _controller.add(false);
      _show(
        title: 'No Internet found',
        msg: 'You can use our services in offline mode',
        bgColor: Colors.red,
        state: false,
      );
    }
  }

  static var _debouncer = CallbackDebouncer(200.milliseconds);
  void listener(ConnectivityResult event) async {
    log(event.toString());
    if (_first) {
      _first = false;
      return;
    }
    // await 1.seconds;
    _debouncer.call(() {
      _checkConnectivity();
    });

    // switch (event) {
    //   case ConnectivityResult.wifi:
    //   case ConnectivityResult.mobile:
    //   case ConnectivityResult.ethernet:
    //     _controller.add(true);
    //     _show(
    //       title: 'Internet found',
    //       msg: 'You can use our services in normal mode',
    //       bgColor: Colors.green,
    //       state: true,
    //     );

    //     break;
    //   case ConnectivityResult.none:
    //     // isConnected = false;
    //     _controller.add(false);

    //     _show(
    //       title: 'No Internet found',
    //       msg: 'You can use our services in offline mode',
    //       bgColor: Colors.red,
    //       state: false,
    //     );

    //     break;
    //   default:
    // }
  }

  void _show({
    required String title,
    required String msg,
    required Color bgColor,
    required bool state,
  }) async {
    if (isConnected == state) return;
    isConnected = state;

    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        icon: Icon(
          state ? Icons.check : Icons.clear,
          color: Colors.white,
        ),
        shouldIconPulse: true,
        message: msg,
        backgroundColor: bgColor,
        duration: 3.seconds,
        isDismissible: true,
        borderRadius: kBorderRadius.bottomLeft.x,
        margin: kPadding,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
      ),
    );
  }
}