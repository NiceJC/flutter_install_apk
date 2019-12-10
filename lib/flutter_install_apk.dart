import 'dart:async';

import 'package:flutter/services.dart';

class FlutterInstallApk {
  static const MethodChannel _channel =
      const MethodChannel('flutter_install_apk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> installApk(String path) async {
    final bool isSuccess = await _channel.invokeMethod('installApk', path);
    return isSuccess;
  }
}



