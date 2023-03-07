import 'dart:convert';

class ESignGetProposalFileResponse {
  ESignGetProposalFileResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  int? code;
  ESignGetProposalFileResponseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory ESignGetProposalFileResponse.fromJson(String str) =>
      ESignGetProposalFileResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignGetProposalFileResponse.fromMap(Map<String, dynamic> json) =>
      ESignGetProposalFileResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : ESignGetProposalFileResponseData.fromMap(json["data"]),
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

class ESignGetProposalFileResponseData {
  ESignGetProposalFileResponseData({
    this.account,
    this.eform,
  });

  ESignGetProposalFileResponseDataAccount? account;
  ESignGetProposalFileResponseDataEform? eform;

  factory ESignGetProposalFileResponseData.fromJson(String str) =>
      ESignGetProposalFileResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignGetProposalFileResponseData.fromMap(Map<String, dynamic> json) =>
      ESignGetProposalFileResponseData(
        account: json["account"] == null
            ? null
            : ESignGetProposalFileResponseDataAccount.fromMap(json["account"]),
        eform: json["eform"] == null
            ? null
            : ESignGetProposalFileResponseDataEform.fromMap(json["eform"]),
      );

  Map<String, dynamic> toMap() => {
        "account": account == null ? null : account?.toMap(),
        "eform": eform == null ? null : eform?.toMap(),
      };
}

class ESignGetProposalFileResponseDataAccount {
  ESignGetProposalFileResponseDataAccount({
    this.userConnectId,
    this.username,
    this.message,
  });

  String? userConnectId;
  String? username;
  String? message;

  factory ESignGetProposalFileResponseDataAccount.fromJson(String str) =>
      ESignGetProposalFileResponseDataAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignGetProposalFileResponseDataAccount.fromMap(
          Map<String, dynamic> json) =>
      ESignGetProposalFileResponseDataAccount(
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

class ESignGetProposalFileResponseDataEform {
  ESignGetProposalFileResponseDataEform({
    this.eFormType,
    this.documentCode,
    this.filePreviewUrl,
    this.identifierDevice,
    this.listImagePreview,
    this.consent,
    this.documentStatus,
  });

  String? eFormType;
  String? documentCode;
  String? filePreviewUrl;
  String? identifierDevice;
  dynamic listImagePreview;
  // DEV MODE
  String? consent;
  int? documentStatus;

  factory ESignGetProposalFileResponseDataEform.fromJson(String str) =>
      ESignGetProposalFileResponseDataEform.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ESignGetProposalFileResponseDataEform.fromMap(
          Map<String, dynamic> json) =>
      ESignGetProposalFileResponseDataEform(
        eFormType: json["eFormType"] == null ? null : json["eFormType"],
        documentCode:
            json["documentCode"] == null ? null : json["documentCode"],
        filePreviewUrl:
            json["filePreviewUrl"] == null ? null : json["filePreviewUrl"],
        identifierDevice:
            json["identifierDevice"] == null ? null : json["identifierDevice"],
        listImagePreview: json["listImagePreview"],
        consent: json["consent"] == null ? null : json["consent"],
        documentStatus:
            json["documentStatus"] == null ? null : json["documentStatus"],
      );

  Map<String, dynamic> toMap() => {
        "eFormType": eFormType == null ? null : eFormType,
        "documentCode": documentCode == null ? null : documentCode,
        "filePreviewUrl": filePreviewUrl == null ? null : filePreviewUrl,
        "identifierDevice": identifierDevice == null ? null : identifierDevice,
        "listImagePreview": listImagePreview,
        "consent": consent == null ? null : consent,
        "documentStatus": documentStatus == null ? null : documentStatus,
      };
}
