import 'dart:convert';

import 'videocall_method_response.dart';

class SchedulesResponse {
  SchedulesResponse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  final int? code;
  final SchedulesResponseData? data;
  final String? message;
  final String? messageCode;
  final String? requestId;
  final String? version;

  factory SchedulesResponse.fromJson(String str) =>
      SchedulesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SchedulesResponse.fromMap(Map<String, dynamic> json) =>
      SchedulesResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : SchedulesResponseData.fromMap(json["data"]),
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

class SchedulesResponseData {
  SchedulesResponseData({
    this.entry,
  });

  final SchedulesResponseDataEntry? entry;

  factory SchedulesResponseData.fromJson(String str) =>
      SchedulesResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SchedulesResponseData.fromMap(Map<String, dynamic> json) =>
      SchedulesResponseData(
        entry: json["entry"] == null
            ? null
            : SchedulesResponseDataEntry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class SchedulesResponseDataEntry {
  SchedulesResponseDataEntry({
    this.id,
    this.code,
    this.userId,
    this.status,
    this.videocallMethodId,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.videocallMethod,
  });

  final int? id;
  final String? code;
  final String? userId;
  final String? status;
  final int? videocallMethodId;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final VideoCallMethodDataEntry? videocallMethod;

  factory SchedulesResponseDataEntry.fromJson(String str) =>
      SchedulesResponseDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SchedulesResponseDataEntry.fromMap(Map<String, dynamic> json) =>
      SchedulesResponseDataEntry(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        userId: json["user_id"] == null ? null : json["user_id"],
        status: json["status"] == null ? null : json["status"],
        videocallMethodId: json["videocall_method_id"] == null
            ? null
            : json["videocall_method_id"],
        phone: json["phone"] == null ? null : json["phone"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        videocallMethod: json["videocall_method"] == null
            ? null
            : VideoCallMethodDataEntry.fromMap(json["videocall_method"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "user_id": userId == null ? null : userId,
        "status": status == null ? null : status,
        "videocall_method_id":
            videocallMethodId == null ? null : videocallMethodId,
        "phone": phone == null ? null : phone,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "videocall_method":
            videocallMethod == null ? null : videocallMethod?.toMap(),
      };

  static final empty = SchedulesResponseDataEntry();
}
