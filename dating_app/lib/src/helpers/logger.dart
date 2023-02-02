import 'dart:developer' as developer;

import 'package:dating_now/src/helpers/app_helpers.dart';
import 'package:dating_now/src/helpers/constants/app_data.dart';

class UtilLogger {
  static const String TAG = 'SALE-BOLT';

  static void log([String tag = TAG, dynamic msg]) {
    if (AppData.mode == MODE_DEV) {
      developer.log('$msg', name: tag);
    }
  }
}
