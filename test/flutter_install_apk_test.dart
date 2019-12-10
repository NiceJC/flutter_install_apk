import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_install_apk/flutter_install_apk.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_install_apk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterInstallApk.platformVersion, '42');
  });
}
