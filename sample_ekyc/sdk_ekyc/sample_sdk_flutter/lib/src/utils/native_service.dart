import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:sample_sdk_flutter/src/utils/app_config.dart';

class NativeService {
  static const MethodChannel platform =
      const MethodChannel('ekyc_method_channel');
  static bool runInNative = false;

  static Future<String> getConfig() async {
    if (runInNative) {
      final result = await platform.invokeMethod('getConfig');
      // load source
      // load url
      // load token
      try {
        Map<String, dynamic> config = jsonDecode(result);
        final source = config['source'] as String?;
        final apiUrl = config['apiUrl'] as String?;
        final token = config['token'] as String?;
        final timeOut = config['timeout'] as int?;
        final email = config['email'] as String?;
        final phone = config['phone'] as String?;
        if (source != null) {
          AppConfig().source = source;
        }
        if (apiUrl != null) {
          AppConfig().apiUrl = apiUrl;
        }
        if (token != null) {
          AppConfig().token = token;
        }
        if (timeOut != null) {
          AppConfig().timeOut = timeOut;
        }
        if (email != null) {
          AppConfig().email = email;
        }
        if (phone != null) {
          AppConfig().phone = phone;
        }
      } catch (e) {
        print(e.toString());
      }
      return result;
    }
    return "";
  }

  static Future<String> initSDKSucceed(bool isSucceed) async {
    if (runInNative) {
      final result = await platform.invokeMethod('initSDKSucceed', {
        'isSucceed': isSucceed,
      });
      return result;
    } else
      return "success";
  }

  static Future<String> generateSessionID(bool isSucceed, String errorCode,
      String errorMessage, String sessionID) async {
    if (runInNative) {
      final result = await platform.invokeMethod('generateSessionID', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'sessionID': sessionID
      });
      return result;
    }
    return "success";
  }

  static Future<String> frontCardDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String frontCardImagePath) async {
    if (runInNative) {
      final result = await platform.invokeMethod('frontCardDeviceCheck', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'frontCardImagePath': frontCardImagePath
      });
      return result;
    }
    return "success";
  }

  static Future<String> frontCardCloudCheck(
      bool isSucceed, String errorCode, String errorMessage) async {
    if (runInNative) {
      final result = await platform.invokeMethod('frontCardCloudCheck', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage
      });
      return result;
    }
    return "success";
  }

  static Future<String> backCardDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String backCardImagePath) async {
    if (runInNative) {
      final result = await platform.invokeMethod('backCardDeviceCheck', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'backCardImagePath': backCardImagePath
      });
      return result;
    }
    return "success";
  }

  static Future<String> backCardCloudCheck(
      bool isSucceed, String errorCode, String errorMessage) async {
    if (runInNative) {
      final result = await platform.invokeMethod('backCardCloudCheck', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage
      });
      return result;
    }
    return "success";
  }

  static Future<String> faceDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String faceVideoPath) async {
    if (runInNative) {
      final result = await platform.invokeMethod('faceDeviceCheck', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'faceVideoPath': faceVideoPath
      });
      return result;
    } else
      return "success";
  }

  static Future<String> faceCloudCheck(
      bool isSucceed, String errorCode, String errorMessage) async {
    if (runInNative) {
      final result = await platform.invokeMethod('faceCloudCheck', {
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage
      });
      return result;
    }
    return "success";
  }

  static Future<String> ekycResult(
      bool isCompleted,
      bool isSucceed,
      String errorCode,
      String errorMessage,
      double similarity,
      String name,
      String dateOfBirth,
      String id,
      String placeOfOrigin,
      String placeOfResidence,
      String dateOfExpiry,
      String dateOfIssue,
      String sex,
      String ethnicity,
      String personalIdentification,
      String nationality) async {
    if (runInNative) {
      final result = await platform.invokeMethod('ekycResult', {
        'isCompleted': isCompleted,
        'isSucceed': isSucceed,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'similarity': similarity,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'id': id,
        'placeOfOrigin': placeOfOrigin,
        'placeOfResidence': placeOfResidence,
        'dateOfExpiry': dateOfExpiry,
        'dateOfIssue': dateOfIssue,
        'sex': sex,
        'ethnicity': ethnicity,
        'personalIdentification': personalIdentification,
        'nationality': nationality,
      });
      return result;
    }
    return "success";
  }

  static Future<String> destroy(bool isCompleted) async {
    if (runInNative) {
      final result =
          await platform.invokeMethod('destroy', {'isCompleted': isCompleted});
      return result;
    }
    return "success";
  }
}
