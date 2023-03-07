import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';


class SdkCallbackExt extends SdkCallback {
  @override
  Future<void> initSDKSucceed(bool isSucceed) async {
    print("initSDKSucceed");
  }

  Future<void> generateSessionID(bool isSucceed, String errorCode,
      String errorMessage, String sessionID) async {
    print("generateSessionID");
  }

  Future<void> frontCardDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String frontCardImagePath) async {
    print("frontCardDeviceCheck");
  }

  Future<void> frontCardCloudCheck(
      bool isSucceed, String errorCode, String errorMessage) async {
    print("frontCardCloudCheck");
  }

  Future<void> backCardDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String backCardImagePath) async {
    print("backCardDeviceCheck");
  }

  Future<void> backCardCloudCheck(
      bool isSucceed, String errorCode, String errorMessage) async {
    print("backCardCloudCheck");
  }

  Future<void> faceDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String faceVideoPath) async {
    print("faceDeviceCheck");
  }

  Future<void> faceCloudCheck(
      bool isSucceed, String errorCode, String errorMessage) async {
    print("faceCloudCheck");
  }

  Future<void> ekycResult(
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
      String nationality,
      String issuedAt,
      ) async {
    print("ekycResult");
  }

  Future<void> destroy(bool isCompleted) async {
    print("destroy");
  }
}
