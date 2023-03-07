class SdkConfig {
  late String apiUrl;
  late String source;
  late String env;
  late String token;
  late int timeOut;
  late String email;
  late String phone;
  late SdkCallback sdkCallback;
  late String backRoute;

  SdkConfig(
      {required this.apiUrl,
      required this.source,
      required this.env,
      required this.token,
      required this.timeOut,
      required this.email,
      required this.phone,
      required this.backRoute,
      required this.sdkCallback});
}

abstract class SdkCallback {
  Future<void> initSDKSucceed(bool isSucceed);

  Future<void> generateSessionID(
      bool isSucceed, String errorCode, String errorMessage, String sessionID);

  Future<void> frontCardDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String frontCardImagePath);

  Future<void> frontCardCloudCheck(
      bool isSucceed, String errorCode, String errorMessage);

  Future<void> backCardDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String backCardImagePath);

  Future<void> backCardCloudCheck(
      bool isSucceed, String errorCode, String errorMessage);

  Future<void> faceDeviceCheck(bool isSucceed, String errorCode,
      String errorMessage, String faceVideoPath);

  Future<void> faceCloudCheck(
      bool isSucceed, String errorCode, String errorMessage);

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
      );

  Future<void> destroy(bool isCompleted);
}
