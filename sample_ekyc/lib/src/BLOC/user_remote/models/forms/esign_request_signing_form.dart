import 'dart:convert';

class ESignRequestSigningForm {
  ESignRequestSigningForm({
    required this.userConnectId,
    required this.userId,
    required this.documentCode,
    required this.location,
    required this.documentId,
    // required this.firebaseToken,
    required this.deviceInfo,
    // required this.signatureBase64,
    required this.imageBase64,
  });

  String userConnectId;
  String userId;
  String documentCode;
  String documentId;
  ESignRequestSigningFormLocation location;
  // String firebaseToken;
  ESignRequestDeviceInfo deviceInfo;
  // String signatureBase64;
  String imageBase64;

  factory ESignRequestSigningForm.fromJson(String str) =>
      ESignRequestSigningForm.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestSigningForm.fromMap(Map<String, dynamic> json) =>
      ESignRequestSigningForm(
        userConnectId:
            json["userConnectId"] == null ? null : json["userConnectId"],
        userId: json["userId"] == null ? null : json["userId"],
        documentId: json["documentId"] == null ? null : json["documentId"],
        documentCode:
            json["documentCode"] == null ? null : json["documentCode"],
        location: ESignRequestSigningFormLocation.fromMap(json["location"]),
        // firebaseToken:
        //     json["firebaseToken"] == null ? null : json["firebaseToken"],
        deviceInfo: ESignRequestDeviceInfo.fromMap(json["deviceInfo"]),
        // signatureBase64:
        //     json["signatureBase64"] == null ? null : json["signatureBase64"],
        imageBase64: json["imageBase64"] == null ? null : json["imageBase64"],
      );

  Map<String, dynamic> toMap() => {
        "userConnectId": userConnectId,
        "documentId": documentId,
        "userId": userId,
        "imageBase64": imageBase64,
        "documentCode": documentCode,
        "location": location.toMap(),
        // "firebaseToken": firebaseToken,
        "deviceInfo": deviceInfo.toMap(),
        // "signatureBase64": signatureBase64,
      };
}

class ESignRequestDeviceInfo {
  ESignRequestDeviceInfo({
    required this.appCodeName,
    required this.appName,
    required this.appVersion,
    required this.appType,
    required this.language,
    required this.deviceType,
    required this.deviceId,
    required this.deviceName,
  });

  String appCodeName;
  String appName;
  String appVersion;
  String appType;
  String language;
  String deviceType;
  String deviceId;
  String deviceName;

  factory ESignRequestDeviceInfo.fromJson(String str) =>
      ESignRequestDeviceInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestDeviceInfo.fromMap(Map<String, dynamic> json) =>
      ESignRequestDeviceInfo(
        appCodeName: json["appCodeName"] == null ? null : json["appCodeName"],
        appName: json["appName"] == null ? null : json["appName"],
        appVersion: json["appVersion"] == null ? null : json["appVersion"],
        appType: json["appType"] == null ? null : json["appType"],
        language: json["language"] == null ? null : json["language"],
        deviceType: json["deviceType"] == null ? null : json["deviceType"],
        deviceId: json["deviceId"] == null ? null : json["deviceId"],
        deviceName: json["deviceName"] == null ? null : json["deviceName"],
      );

  Map<String, dynamic> toMap() => {
        "appCodeName": appCodeName,
        "appName": appName,
        "appVersion": appVersion,
        "appType": appType,
        "language": language,
        "deviceType": deviceType,
        "deviceId": deviceId,
        "deviceName": deviceName,
      };
}

class ESignRequestSigningFormLocation {
  ESignRequestSigningFormLocation({
    required this.latitude,
    required this.longitude,
    required this.geoLocation,
  });

  double latitude;
  double longitude;
  String geoLocation;

  factory ESignRequestSigningFormLocation.fromJson(String str) =>
      ESignRequestSigningFormLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestSigningFormLocation.fromMap(Map<String, dynamic> json) =>
      ESignRequestSigningFormLocation(
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        geoLocation: json["geoLocation"] == null ? null : json["geoLocation"],
      );

  Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
        "geoLocation": geoLocation,
      };
}
