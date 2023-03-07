import 'dart:convert';

class ESignRequestSigningResponse {
  ESignRequestSigningResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.messageCode,
    required this.requestId,
    required this.version,
  });

  final int? code;
  final ESignRequestSigningResponseData? data;
  final String? message;
  final String? messageCode;
  final String? requestId;
  final String? version;

  factory ESignRequestSigningResponse.fromJson(String str) =>
      ESignRequestSigningResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestSigningResponse.fromMap(Map<String, dynamic> json) =>
      ESignRequestSigningResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : ESignRequestSigningResponseData.fromMap(json["data"]),
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

class ESignRequestSigningResponseData {
  ESignRequestSigningResponseData({
    required this.account,
    required this.entry,
  });

  final ESignRequestSigningResponseDataAccount? account;
  final ESignRequestSigningResponseDataEntry? entry;

  factory ESignRequestSigningResponseData.fromJson(String str) =>
      ESignRequestSigningResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestSigningResponseData.fromMap(Map<String, dynamic> json) =>
      ESignRequestSigningResponseData(
        account: json["account"] == null
            ? null
            : ESignRequestSigningResponseDataAccount.fromMap(json["account"]),
        entry: json["entry"] == null
            ? null
            : ESignRequestSigningResponseDataEntry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "account": account == null ? null : account?.toMap(),
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class ESignRequestSigningResponseDataAccount {
  ESignRequestSigningResponseDataAccount({
    required this.userConnectId,
    required this.username,
    required this.message,
  });

  final String? userConnectId;
  final String? username;
  final String? message;

  factory ESignRequestSigningResponseDataAccount.fromJson(String str) =>
      ESignRequestSigningResponseDataAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestSigningResponseDataAccount.fromMap(
          Map<String, dynamic> json) =>
      ESignRequestSigningResponseDataAccount(
        userConnectId:
            json["userConnectId"] == null ? null : json["userConnectId"],
        username: json["username"] == null ? null : json["username"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "userConnectId": userConnectId == null ? null : userConnectId,
        "username": username == null ? null : username,
        "message": message == null ? null : message,
      };
}

class ESignRequestSigningResponseDataEntry {
  ESignRequestSigningResponseDataEntry({
    required this.documentTypeCode,
    required this.documentTypeName,
    required this.document3RdId,
    required this.documentCode,
    required this.documentName,
    required this.documentStatus,
    required this.state,
    required this.fileUrl,
    required this.workFlowUser,
  });

  final String? documentTypeCode;
  final String? documentTypeName;
  final String? document3RdId;
  final String? documentCode;
  final String? documentName;
  final int? documentStatus;
  final String? state;
  final String? fileUrl;
  final List<WorkFlowUser>? workFlowUser;

  factory ESignRequestSigningResponseDataEntry.fromJson(String str) =>
      ESignRequestSigningResponseDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignRequestSigningResponseDataEntry.fromMap(
          Map<String, dynamic> json) =>
      ESignRequestSigningResponseDataEntry(
        documentTypeCode:
            json["documentTypeCode"] == null ? null : json["documentTypeCode"],
        documentTypeName:
            json["documentTypeName"] == null ? null : json["documentTypeName"],
        document3RdId:
            json["document3rdId"] == null ? null : json["document3rdId"],
        documentCode:
            json["documentCode"] == null ? null : json["documentCode"],
        documentName:
            json["documentName"] == null ? null : json["documentName"],
        documentStatus:
            json["documentStatus"] == null ? null : json["documentStatus"],
        state: json["state"] == null ? null : json["state"],
        fileUrl: json["fileUrl"] == null ? null : json["fileUrl"],
        workFlowUser: json["workFlowUser"] == null
            ? null
            : List<WorkFlowUser>.from(
                json["workFlowUser"].map((x) => WorkFlowUser.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "documentTypeCode": documentTypeCode == null ? null : documentTypeCode,
        "documentTypeName": documentTypeName == null ? null : documentTypeName,
        "document3rdId": document3RdId == null ? null : document3RdId,
        "documentCode": documentCode == null ? null : documentCode,
        "documentName": documentName == null ? null : documentName,
        "documentStatus": documentStatus == null ? null : documentStatus,
        "state": state == null ? null : state,
        "fileUrl": fileUrl == null ? null : fileUrl,
        "workFlowUser": workFlowUser == null
            ? null
            : List<dynamic>.from((workFlowUser ?? []).map((x) => x.toMap())),
      };
}

class WorkFlowUser {
  WorkFlowUser({
    required this.userConnectId,
    required this.userFullName,
    required this.userEmail,
    required this.userPhoneNumber,
    required this.state,
    required this.signAtDate,
  });

  final String? userConnectId;
  final String? userFullName;
  final String? userEmail;
  final String? userPhoneNumber;
  final String? state;
  final String? signAtDate;

  factory WorkFlowUser.fromJson(String str) =>
      WorkFlowUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkFlowUser.fromMap(Map<String, dynamic> json) => WorkFlowUser(
        userConnectId:
            json["userConnectId"] == null ? null : json["userConnectId"],
        userFullName:
            json["userFullName"] == null ? null : json["userFullName"],
        userEmail: json["userEmail"] == null ? null : json["userEmail"],
        userPhoneNumber:
            json["userPhoneNumber"] == null ? null : json["userPhoneNumber"],
        state: json["state"] == null ? null : json["state"],
        signAtDate: json["signAtDate"] == null ? null : json["signAtDate"],
      );

  Map<String, dynamic> toMap() => {
        "userConnectId": userConnectId == null ? null : userConnectId,
        "userFullName": userFullName == null ? null : userFullName,
        "userEmail": userEmail == null ? null : userEmail,
        "userPhoneNumber": userPhoneNumber == null ? null : userPhoneNumber,
        "state": state == null ? null : state,
        "signAtDate": signAtDate == null ? null : signAtDate,
      };
}
