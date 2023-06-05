import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:spam_sms/core/utils/logger_util.dart';

class DeviceInfoHelper {
  static final DeviceInfoHelper _instance = DeviceInfoHelper._internal();

  factory DeviceInfoHelper() {
    return _instance;
  }

  DeviceInfoHelper._internal();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static AndroidDeviceInfo? _androidDeviceInfo;
  static IosDeviceInfo? _iosDeviceInfo;

  static Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        _androidDeviceInfo = await _deviceInfoPlugin.androidInfo;

        return;
      } else if (Platform.isIOS) {
        _iosDeviceInfo = await _deviceInfoPlugin.iosInfo;

        return;
      }
    } on PlatformException {
      logger.e('Lỗi không thể lấy thông tin thiết bị');
    }

    return;
  }

  static int? sdkVersionInt() {
    if (Platform.isAndroid) {
      return _androidDeviceInfo?.version.previewSdkInt;
    } else if (Platform.isIOS) {
      return double.tryParse(_iosDeviceInfo?.systemVersion ?? '')?.toInt();
    }

    return null;
  }
}
