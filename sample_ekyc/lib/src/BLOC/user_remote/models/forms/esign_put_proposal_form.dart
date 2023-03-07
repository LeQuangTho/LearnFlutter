import 'dart:convert';

import 'esign_get_proposal_form.dart';

class ESignPropsalPutForm {
  ESignPropsalPutForm({
    this.userConnectId,
    this.documentCode,
    this.location,
    this.deviceInfo,
  });

  String? userConnectId;
  String? documentCode;
  ESignLocation? location;
  ESignPutFormDeviceInfo? deviceInfo;

  factory ESignPropsalPutForm.fromJson(String str) =>
      ESignPropsalPutForm.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignPropsalPutForm.fromMap(Map<String, dynamic> json) =>
      ESignPropsalPutForm(
        userConnectId:
            json["userConnectId"] == null ? null : json["userConnectId"],
        documentCode:
            json["documentCode"] == null ? null : json["documentCode"],
        location: json["location"] == null
            ? null
            : ESignLocation.fromMap(json["location"]),
        deviceInfo: json["deviceInfo"] == null
            ? null
            : ESignPutFormDeviceInfo.fromMap(json["deviceInfo"]),
      );

  Map<String, dynamic> toMap() => {
        "userConnectId": userConnectId == null ? null : userConnectId,
        "documentCode": documentCode == null ? null : documentCode,
        "location": location == null ? null : location?.toMap(),
        "deviceInfo": deviceInfo == null ? null : deviceInfo?.toMap(),
      };
}

class ESignPutFormDeviceInfo {
  ESignPutFormDeviceInfo({
    this.appCodeName,
    this.appName,
    this.appVersion,
    this.language,
    this.deviceType,
    this.deviceId,
    this.deviceName,
  });

  String? appCodeName;
  String? appName;
  String? appVersion;
  String? language;
  String? deviceType;
  String? deviceId;
  String? deviceName;

  factory ESignPutFormDeviceInfo.fromJson(String str) =>
      ESignPutFormDeviceInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignPutFormDeviceInfo.fromMap(Map<String, dynamic> json) =>
      ESignPutFormDeviceInfo(
        appCodeName: json["appCodeName"] == null ? null : json["appCodeName"],
        appName: json["appName"] == null ? null : json["appName"],
        appVersion: json["appVersion"] == null ? null : json["appVersion"],
        language: json["language"] == null ? null : json["language"],
        deviceType: json["deviceType"] == null ? null : json["deviceType"],
        deviceId: json["deviceId"] == null ? null : json["deviceId"],
        deviceName: json["deviceName"] == null ? null : json["deviceName"],
      );

  Map<String, dynamic> toMap() => {
        "appCodeName": appCodeName == null ? null : appCodeName,
        "appName": appName == null ? null : appName,
        "appVersion": appVersion == null ? null : appVersion,
        "language": language == null ? null : language,
        "deviceType": deviceType == null ? null : deviceType,
        "deviceId": deviceId == null ? null : deviceId,
        "deviceName": deviceName == null ? null : deviceName,
      };
}
