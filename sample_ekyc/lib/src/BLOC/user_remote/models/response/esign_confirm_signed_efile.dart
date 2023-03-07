import 'dart:convert';

class ConfirmSigningEFileResponse {
  ConfirmSigningEFileResponse({
    required this.code,
    required this.data,
    required this.message,
    // required this.messageCode,
    // required this.requestId,
    // required this.version,
  });

  final int code;
  final bool data;
  final String message;
  // final String messageCode;
  // final String requestId;
  // final String version;

  factory ConfirmSigningEFileResponse.fromJson(String str) =>
      ConfirmSigningEFileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConfirmSigningEFileResponse.fromMap(Map<String, dynamic> json) =>
      ConfirmSigningEFileResponse(
        code: json["code"] == null ? null : json["code"],
        // data: ConfirmSigningEFileResponseData.fromMap(json["data"]),
        data: json["data"] == null ? null : json["data"],
        message: json["message"] == null ? null : json["message"],
        // messageCode: json["message_code"] == null ? null : json["message_code"],
        // requestId: json["request_id"] == null ? null : json["request_id"],
        // version: json["version"] == null ? null : json["version"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        // "data": data.toMap(),
        "data": data,
        "message": message,
        // "message_code": messageCode,
        // "request_id": requestId,
        // "version": version,
      };
}

class ConfirmSigningEFileResponseData {
  ConfirmSigningEFileResponseData({
    required this.account,
    required this.result,
  });

  final Account account;
  final Result result;

  factory ConfirmSigningEFileResponseData.fromJson(String str) =>
      ConfirmSigningEFileResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConfirmSigningEFileResponseData.fromMap(Map<String, dynamic> json) =>
      ConfirmSigningEFileResponseData(
        account: Account.fromMap(json["account"]),
        result: Result.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "account": account.toMap(),
        "result": result.toMap(),
      };
}

class Account {
  Account({
    required this.userConnectId,
    required this.username,
    required this.message,
  });

  final String userConnectId;
  final String username;
  final String message;

  factory Account.fromJson(String str) => Account.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Account.fromMap(Map<String, dynamic> json) => Account(
        userConnectId:
            json["userConnectId"] == null ? null : json["userConnectId"],
        username: json["username"] == null ? null : json["username"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "userConnectId": userConnectId,
        "username": username,
        "message": message,
      };
}

class Result {
  Result({
    required this.data,
    required this.code,
    required this.message,
    required this.traceId,
  });

  final dynamic data;
  final int code;
  final String message;
  final String traceId;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        data: json["data"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        traceId: json["traceId"] == null ? null : json["traceId"],
      );

  Map<String, dynamic> toMap() => {
        "data": data,
        "code": code,
        "message": message,
        "traceId": traceId,
      };
}
