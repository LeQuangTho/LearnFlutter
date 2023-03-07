// To parse this JSON data, do
//
//     final userProfileUpdateAvatarResopnse = userProfileUpdateAvatarResopnseFromMap(jsonString);

import 'dart:convert';

class UserProfileUpdateAvatarResopnse {
  UserProfileUpdateAvatarResopnse({
    this.code,
    this.data,
    this.message,
    this.messageCode,
    this.requestId,
    this.version,
  });

  int? code;
  UserProfileUpdateAvatarResopnseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory UserProfileUpdateAvatarResopnse.fromJson(String str) =>
      UserProfileUpdateAvatarResopnse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileUpdateAvatarResopnse.fromMap(Map<String, dynamic> json) =>
      UserProfileUpdateAvatarResopnse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : UserProfileUpdateAvatarResopnseData.fromMap(json["data"]),
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

class UserProfileUpdateAvatarResopnseData {
  UserProfileUpdateAvatarResopnseData({
    this.fileDetail,
    this.url,
  });

  FileDetail? fileDetail;
  String? url;

  factory UserProfileUpdateAvatarResopnseData.fromJson(String str) =>
      UserProfileUpdateAvatarResopnseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileUpdateAvatarResopnseData.fromMap(
          Map<String, dynamic> json) =>
      UserProfileUpdateAvatarResopnseData(
        fileDetail: json["fileDetail"] == null
            ? null
            : FileDetail.fromMap(json["fileDetail"]),
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "fileDetail": fileDetail == null ? null : fileDetail?.toMap(),
        "url": url == null ? null : url,
      };
}

class FileDetail {
  FileDetail({
    this.scheme,
    this.opaque,
    this.user,
    this.host,
    this.path,
    this.rawPath,
    this.forceQuery,
    this.rawQuery,
    this.fragment,
    this.rawFragment,
  });

  String? scheme;
  String? opaque;
  dynamic user;
  String? host;
  String? path;
  String? rawPath;
  bool? forceQuery;
  String? rawQuery;
  String? fragment;
  String? rawFragment;

  factory FileDetail.fromJson(String str) =>
      FileDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FileDetail.fromMap(Map<String, dynamic> json) => FileDetail(
        scheme: json["Scheme"] == null ? null : json["Scheme"],
        opaque: json["Opaque"] == null ? null : json["Opaque"],
        user: json["User"],
        host: json["Host"] == null ? null : json["Host"],
        path: json["Path"] == null ? null : json["Path"],
        rawPath: json["RawPath"] == null ? null : json["RawPath"],
        forceQuery: json["ForceQuery"] == null ? null : json["ForceQuery"],
        rawQuery: json["RawQuery"] == null ? null : json["RawQuery"],
        fragment: json["Fragment"] == null ? null : json["Fragment"],
        rawFragment: json["RawFragment"] == null ? null : json["RawFragment"],
      );

  Map<String, dynamic> toMap() => {
        "Scheme": scheme == null ? null : scheme,
        "Opaque": opaque == null ? null : opaque,
        "User": user,
        "Host": host == null ? null : host,
        "Path": path == null ? null : path,
        "RawPath": rawPath == null ? null : rawPath,
        "ForceQuery": forceQuery == null ? null : forceQuery,
        "RawQuery": rawQuery == null ? null : rawQuery,
        "Fragment": fragment == null ? null : fragment,
        "RawFragment": rawFragment == null ? null : rawFragment,
      };
}
