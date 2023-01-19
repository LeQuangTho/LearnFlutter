import 'dart:developer' as developer;

import 'app_helpers.dart';
import 'constants/app_data.dart';

class UtilLogger {
  static const String TAG = 'SALE-BOLT';

  static void log([String tag = TAG, dynamic msg]) {
    if (AppData.mode == MODE_DEV) {
      developer.log('$msg', name: tag);
    }
  }
}
