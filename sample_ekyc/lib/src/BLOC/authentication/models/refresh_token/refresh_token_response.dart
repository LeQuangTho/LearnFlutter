import 'dart:convert';

class RefreshTokenResponse {
  RefreshTokenResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  int? code;
  RefreshTokenResponseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory RefreshTokenResponse.fromJson(String str) =>
      RefreshTokenResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RefreshTokenResponse.fromMap(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : RefreshTokenResponseData.fromMap(json["data"]),
        message: json["message"] == null ? null : json["message"],
        messageCode: json["message_code"] == null ? null : json["message_code"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        version: json["version"] == null ? null : json["version"],
      );

  Map<String, dynamic> toMap() => {
        "code": code == null ? null : code,
        "data": data == null ? null : data?.toMap(),
        "message": message == null ? null : message,
        "message_code": messageCode == null ? null : messageCode,
        "request_id": requestId == null ? null : requestId,
        "version": version == null ? null : version,
      };
}

class RefreshTokenResponseData {
  RefreshTokenResponseData({
    this.accessToken,
    this.expiresIn,
  });

  String? accessToken;
  int? expiresIn;

  factory RefreshTokenResponseData.fromJson(String str) =>
      RefreshTokenResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RefreshTokenResponseData.fromMap(Map<String, dynamic> json) =>
      RefreshTokenResponseData(
        accessToken: json["access_token"] == null ? null : json["access_token"],
        expiresIn: json["expires_in"] == null ? null : json["expires_in"],
      );

  Map<String, dynamic> toMap() => {
        "access_token": accessToken == null ? null : accessToken,
        "expires_in": expiresIn == null ? null : expiresIn,
      };
}
