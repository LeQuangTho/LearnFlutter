import 'dart:convert';

class ESignGetProposalFileForm {
  ESignGetProposalFileForm({
    this.deviceInfo,
    this.location,
  });

  ESignDeviceInfo? deviceInfo;
  ESignLocation? location;

  factory ESignGetProposalFileForm.fromJson(String str) =>
      ESignGetProposalFileForm.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignGetProposalFileForm.fromMap(Map<String, dynamic> json) =>
      ESignGetProposalFileForm(
        deviceInfo: json["deviceInfo"] == null
            ? null
            : ESignDeviceInfo.fromMap(json["deviceInfo"]),
        location: json["location"] == null
            ? null
            : ESignLocation.fromMap(json["location"]),
      );

  Map<String, dynamic> toMap() => {
        "deviceInfo": deviceInfo == null ? null : deviceInfo?.toMap(),
        "location": location == null ? null : location?.toMap(),
      };
}

class ESignDeviceInfo {
  ESignDeviceInfo({
    this.deviceType,
    this.deviceId,
    this.deviceName,
  });

  String? deviceType;
  String? deviceId;
  String? deviceName;

  factory ESignDeviceInfo.fromJson(String str) =>
      ESignDeviceInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignDeviceInfo.fromMap(Map<String, dynamic> json) => ESignDeviceInfo(
        deviceType: json["deviceType"] == null ? null : json["deviceType"],
        deviceId: json["deviceId"] == null ? null : json["deviceId"],
        deviceName: json["deviceName"] == null ? null : json["deviceName"],
      );

  Map<String, dynamic> toMap() => {
        "deviceType": deviceType == null ? null : deviceType,
        "deviceId": deviceId == null ? null : deviceId,
        "deviceName": deviceName == null ? null : deviceName,
      };
}

class ESignLocation {
  ESignLocation({
    this.latitude,
    this.longitude,
    this.geoLocation,
  });

  double? latitude;
  double? longitude;
  String? geoLocation;

  factory ESignLocation.fromJson(String str) =>
      ESignLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignLocation.fromMap(Map<String, dynamic> json) => ESignLocation(
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        geoLocation: json["geoLocation"] == null ? null : json["geoLocation"],
      );

  Map<String, dynamic> toMap() => {
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "geoLocation": geoLocation == null ? null : geoLocation,
      };
}
