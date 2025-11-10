import 'dart:async';

import 'package:flutter/services.dart';

class ScreenshotCallback {
  static final ScreenshotCallback _singleton = ScreenshotCallback._internal();
  static ScreenshotCallback get instance => _singleton;

  ScreenshotCallback._internal() {
    initialize();
  }

  static const MethodChannel _channel = const MethodChannel('flutter.moum/screenshot_callback');

  /// Functions to execute when callback fired.
  List<VoidCallback> onCallbacks = <VoidCallback>[];

  /// Initializes screenshot callback plugin.
  Future<void> initialize() async {
    _channel.setMethodCallHandler(_handleMethod);
    await _channel.invokeMethod('initialize');
  }

  /// Add void callback.
  void addListener(VoidCallback callback) {
    onCallbacks.add(callback);
  }

  /// Remove void callback.
  void removeListener(VoidCallback callback) {
    onCallbacks.remove(callback);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onCallback':
        // for (final callback in onCallbacks) {
        //   callback();
        // }
        // exc last call
        final callback = onCallbacks.lastOrNull;
        callback?.call();
        break;
      default:
        throw ('method not defined');
    }
  }

  /// Remove callback listener.
  Future<void> dispose() async => await _channel.invokeMethod('dispose');
}
