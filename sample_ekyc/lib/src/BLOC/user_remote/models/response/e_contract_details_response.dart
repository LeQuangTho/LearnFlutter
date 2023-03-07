import 'dart:convert';

class EContractDetailsResponse {
  EContractDetailsResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  int? code;
  EContractDetailsResponseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory EContractDetailsResponse.fromJson(String str) =>
      EContractDetailsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractDetailsResponse.fromMap(Map<String, dynamic> json) =>
      EContractDetailsResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : EContractDetailsResponseData.fromMap(json["data"]),
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

class EContractDetailsResponseData {
  EContractDetailsResponseData({
    this.account,
    this.entry,
  });

  Account? account;
  EContractDetailsResponseDataEntry? entry;

  factory EContractDetailsResponseData.fromJson(String str) =>
      EContractDetailsResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractDetailsResponseData.fromMap(Map<String, dynamic> json) =>
      EContractDetailsResponseData(
        account:
            json["account"] == null ? null : Account.fromMap(json["account"]),
        entry: json["entry"] == null
            ? null
            : EContractDetailsResponseDataEntry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "account": account == null ? null : account?.toMap(),
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class Account {
  Account({
    this.userConnectId,
    this.username,
    this.message,
  });

  String? userConnectId;
  String? username;
  String? message;

  factory Account.fromJson(String str) => Account.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Account.fromMap(Map<String, dynamic> json) => Account(
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

class EContractDetailsResponseDataEntry {
  EContractDetailsResponseDataEntry({
    this.documentTypeCode,
    this.documentTypeName,
    this.document3RdId,
    this.documentCode,
    this.documentName,
    this.documentStatus,
    this.state,
    this.fileUrl,
    this.workFlowUser,
  });

  String? documentTypeCode;
  String? documentTypeName;
  String? document3RdId;
  String? documentCode;
  String? documentName;
  int? documentStatus;
  String? state;
  String? fileUrl;
  List<WorkFlowUser>? workFlowUser;

  factory EContractDetailsResponseDataEntry.fromJson(String str) =>
      EContractDetailsResponseDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractDetailsResponseDataEntry.fromMap(
          Map<String, dynamic> json) =>
      EContractDetailsResponseDataEntry(
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
    this.userConnectId,
    this.userFullName,
    this.userEmail,
    this.userPhoneNumber,
    this.state,
    this.signAtDate,
  });

  String? userConnectId;
  String? userFullName;
  String? userEmail;
  String? userPhoneNumber;
  String? state;
  String? signAtDate;

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
