import 'dart:async';

import 'package:flutter/material.dart';

class CallbackDebouncer {
  /// {@macro callback_debouncer}
  CallbackDebouncer(this._delay);

  final Duration _delay;
  Timer? _timer;

  /// Calls the given [callback] after the given duration has passed.
  void call(VoidCallback callback) {
    if (_delay == Duration.zero) {
      callback();
    } else {
      _timer?.cancel();
      _timer = Timer(_delay, callback);
    }
  }
}
