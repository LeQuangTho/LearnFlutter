class DetailCtsModel {
  DetailCtsModel({
    this.id,
    this.createdDate,
    this.subjectDn,
    this.validFrom,
    this.validTo,
    this.certificateBase64,
    this.chainCertificateBase64,
    this.certificateInfo,
  });

  String? id;
  DateTime? createdDate;
  String? subjectDn;
  DateTime? validFrom;
  DateTime? validTo;
  String? certificateBase64;
  List<String>? chainCertificateBase64;
  CertificateInfo? certificateInfo;

  factory DetailCtsModel.fromJson(Map<String, dynamic> json) => DetailCtsModel(
        id: json["id"],
        createdDate: DateTime.parse(json["createdDate"]),
        subjectDn: json["subjectDN"],
        validFrom: DateTime.parse(json["validFrom"]),
        validTo: DateTime.parse(json["validTo"]),
        certificateBase64: json["certificateBase64"],
        chainCertificateBase64:
            List<String>.from(json["chainCertificateBase64"].map((x) => x)),
        certificateInfo: CertificateInfo.fromJson(json["certificateInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdDate": createdDate,
        "subjectDN": subjectDn,
        "validFrom": validFrom,
        "validTo": validTo,
        "certificateBase64": certificateBase64,
        "chainCertificateBase64":
            List<dynamic>.from(chainCertificateBase64!.map((x) => x)),
        "certificateInfo": certificateInfo?.toJson(),
      };
  static final empty = DetailCtsModel();
}

class CertificateInfo {
  CertificateInfo({
    this.version,
    this.serialNumber,
    this.subjectName,
    this.issuerName,
    this.signatureAlgorithm,
    this.notBefore,
    this.notAfter,
    this.subject,
    this.issuer,
  });

  int? version;
  String? serialNumber;
  String? subjectName;
  String? issuerName;
  String? signatureAlgorithm;
  DateTime? notBefore;
  DateTime? notAfter;
  String? subject;
  String? issuer;

  factory CertificateInfo.fromJson(Map<String, dynamic> json) =>
      CertificateInfo(
        version: json["version"],
        serialNumber: json["serialNumber"],
        subjectName: json["subjectName"],
        issuerName: json["issuerName"],
        signatureAlgorithm: json["signatureAlgorithm"],
        notBefore: DateTime.parse(json["notBefore"]),
        notAfter: DateTime.parse(json["notAfter"]),
        subject: json["subject"],
        issuer: json["issuer"],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "serialNumber": serialNumber,
        "subjectName": subjectName,
        "issuerName": issuerName,
        "signatureAlgorithm": signatureAlgorithm,
        "notBefore": notBefore,
        "notAfter": notAfter,
        "subject": subject,
        "issuer": issuer,
      };
}
