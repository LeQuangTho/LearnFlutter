import 'dart:convert';

class ConfirmSigningEFileForm {
  ConfirmSigningEFileForm({
    required this.requestId,
    required this.documentId,
    required this.sadRequestId,
    required this.deviceId,
    required this.userId,
    // required this.organization,
    // required this.organizationUnit,
    required this.otp,
    required this.signType,
     this.idHSM,
    required this.jwt,
  });

  final String requestId;
  final String sadRequestId;
  final String documentId;
  final String deviceId;
  final String userId;
  final String? idHSM;
  final bool signType;
  // final String organization;
  // final String organizationUnit;
  final String otp;
  final String jwt;

  factory ConfirmSigningEFileForm.fromJson(String str) =>
      ConfirmSigningEFileForm.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConfirmSigningEFileForm.fromMap(Map<String, dynamic> json) =>
      ConfirmSigningEFileForm(
        requestId: json["requestId"] == null ? null : json["requestId"],
        idHSM: json["idHSM"] == null ? null : json["idHSM"],
        userId: json["userId"] == null ? null : json["userId"],
        documentId: json["documentId"] == null ? null : json["documentId"],
        signType: json["signType"] == null ? null : json["signType"],
        sadRequestId:
            json["sadRequestId"] == null ? null : json["sadRequestId"],
        deviceId: json["deviceId"] == null ? null : json["deviceId"],
        // organization:
        //     json["organization"] == null ? null : json["organization"],
        // organizationUnit:
        //     json["organizationUnit"] == null ? null : json["organizationUnit"],
        otp: json["otp"] == null ? null : json["otp"],
        jwt: json["jwt"] == null ? null : json["jwt"],
      );

  Map<String, dynamic> toMap() => {
        "requestId": requestId,
        "idHSM": idHSM,
        "userId": userId,
        "documentId": documentId,
        "signType": signType,
        "sadRequestId": sadRequestId,
        "deviceId": deviceId,
        // "organization": organization,
        // "organizationUnit": organizationUnit,
        "otp": otp,
        "jwt": jwt,
      };
}
