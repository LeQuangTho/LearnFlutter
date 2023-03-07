import 'dart:convert';

class EContractResponse {
  EContractResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  int? code;
  EContractResponseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory EContractResponse.fromJson(String str) =>
      EContractResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractResponse.fromMap(Map<String, dynamic> json) =>
      EContractResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : EContractResponseData.fromMap(json["data"]),
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

class EContractResponseData {
  EContractResponseData({
    this.account,
    this.entries,
  });

  EContractResponseDataAccount? account;
  List<EContractResponseDataEntry>? entries;

  factory EContractResponseData.fromJson(String str) =>
      EContractResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractResponseData.fromMap(Map<String, dynamic> json) =>
      EContractResponseData(
        account: json["account"] == null
            ? null
            : EContractResponseDataAccount.fromMap(json["account"]),
        entries: json["entries"] == null
            ? null
            : List<EContractResponseDataEntry>.from(json["entries"]
                .map((x) => EContractResponseDataEntry.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "account": account == null ? null : account?.toMap(),
        "entries": entries == null
            ? null
            : List<dynamic>.from((entries ?? []).map((x) => x.toMap())),
      };
}

class EContractResponseDataAccount {
  EContractResponseDataAccount({
    this.userConnectId,
    this.username,
    this.message,
  });

  String? userConnectId;
  String? username;
  String? message;

  factory EContractResponseDataAccount.fromJson(String str) =>
      EContractResponseDataAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractResponseDataAccount.fromMap(Map<String, dynamic> json) =>
      EContractResponseDataAccount(
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

class EContractResponseDataEntry {
  EContractResponseDataEntry({
    this.documentTypeCode,
    this.documentTypeName,
    this.documentCode,
    this.documentName,
    this.documentStatus,
    this.state,
    this.isSign,
    this.createdDate,
  });

  String? documentTypeCode;
  String? documentTypeName;
  String? documentCode;
  String? documentName;
  int? documentStatus;
  String? state;
  bool? isSign;
  DateTime? createdDate;

  factory EContractResponseDataEntry.fromJson(String str) =>
      EContractResponseDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EContractResponseDataEntry.fromMap(Map<String, dynamic> json) =>
      EContractResponseDataEntry(
        documentTypeCode:
            json["documentTypeCode"] == null ? null : json["documentTypeCode"],
        documentTypeName:
            json["documentTypeName"] == null ? null : json["documentTypeName"],
        documentCode:
            json["documentCode"] == null ? null : json["documentCode"],
        documentName:
            json["documentName"] == null ? null : json["documentName"],
        documentStatus:
            json["documentStatus"] == null ? null : json["documentStatus"],
        state: json["state"] == null ? null : json["state"],
        isSign: json["isSign"] == null ? null : json["isSign"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toMap() => {
        "documentTypeCode": documentTypeCode == null ? null : documentTypeCode,
        "documentTypeName": documentTypeName == null ? null : documentTypeName,
        "documentCode": documentCode == null ? null : documentCode,
        "documentName": documentName == null ? null : documentName,
        "documentStatus": documentStatus == null ? null : documentStatus,
        "state": state == null ? null : state,
        "isSign": isSign == null ? null : isSign,
        "createdDate":
            createdDate == null ? null : createdDate?.toIso8601String(),
      };
}
