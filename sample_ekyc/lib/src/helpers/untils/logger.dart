import 'dart:developer' as developer;

import 'package:hdsaison_signing/src/constants/hard_constants.dart';

import '../../configs/application.dart';

class UtilLogger {
  static const String TAG = "SALEBOLT";

  static log([String tag = TAG, dynamic msg]) {
    if (AppData.mode == MODE_DEV) {
      developer.log('$msg', name: tag);
    }
  }

  ///Singleton factory
  static final UtilLogger _instance = UtilLogger._internal();

  factory UtilLogger() {
    return _instance;
  }

  UtilLogger._internal();
}
