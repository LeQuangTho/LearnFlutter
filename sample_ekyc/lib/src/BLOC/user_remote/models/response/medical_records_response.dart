// To parse this JSON data, do
//
//     final medicalRecordResponse = medicalRecordResponseFromMap(jsonString);

import 'dart:convert';

class MedicalRecordResponse {
  MedicalRecordResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  int? code;
  MedicalRecordResponseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory MedicalRecordResponse.fromJson(String str) =>
      MedicalRecordResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MedicalRecordResponse.fromMap(Map<String, dynamic> json) =>
      MedicalRecordResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : MedicalRecordResponseData.fromMap(json["data"]),
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

class MedicalRecordResponseData {
  MedicalRecordResponseData({
    this.entry,
  });

  MedicalRecordResponseDataEntry? entry;

  factory MedicalRecordResponseData.fromJson(String str) =>
      MedicalRecordResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MedicalRecordResponseData.fromMap(Map<String, dynamic> json) =>
      MedicalRecordResponseData(
        entry: json["entry"] == null
            ? null
            : MedicalRecordResponseDataEntry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class MedicalRecordResponseDataEntry {
  MedicalRecordResponseDataEntry({
    this.total,
    this.pending,
  });

  int? total;
  int? pending;

  factory MedicalRecordResponseDataEntry.fromJson(String str) =>
      MedicalRecordResponseDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MedicalRecordResponseDataEntry.fromMap(Map<String, dynamic> json) =>
      MedicalRecordResponseDataEntry(
        total: json["total"] == null ? null : json["total"],
        pending: json["pending"] == null ? null : json["pending"],
      );

  Map<String, dynamic> toMap() => {
        "total": total == null ? null : total,
        "pending": pending == null ? null : pending,
      };
  static final empty = MedicalRecordResponseDataEntry();
}
