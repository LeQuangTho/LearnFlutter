// import 'dart:convert';

// import 'user_infor_response.dart';

// class QRResponse {
//   QRResponse({
//     this.code,
//     this.data,
//     this.message,
//     this.messageCode,
//     this.requestId,
//     this.version,
//   });

//   int? code;
//   QrScanResultData? data;
//   String? message;
//   String? messageCode;
//   String? requestId;
//   String? version;

//   factory QRResponse.fromJson(String str) =>
//       QRResponse.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory QRResponse.fromMap(Map<String, dynamic> json) => QRResponse(
//         code: json["code"] == null ? null : json["code"],
//         data: json["data"] == null
//             ? null
//             : QrScanResultData.fromMap(json["data"]),
//         message: json["message"] == null ? null : json["message"],
//         messageCode: json["message_code"] == null ? null : json["message_code"],
//         requestId: json["request_id"] == null ? null : json["request_id"],
//         version: json["version"] == null ? null : json["version"],
//       );

//   Map<String, dynamic> toMap() => {
//         "code": code == null ? null : code,
//         "data": data == null ? null : data?.toMap(),
//         "message": message == null ? null : message,
//         "message_code": messageCode == null ? null : messageCode,
//         "request_id": requestId == null ? null : requestId,
//         "version": version == null ? null : version,
//       };
// }

// class QrScanResultData {
//   QrScanResultData({
//     this.entry,
//   });

//   QrScanResultDataEntry? entry;

//   factory QrScanResultData.fromJson(String str) =>
//       QrScanResultData.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory QrScanResultData.fromMap(Map<String, dynamic> json) =>
//       QrScanResultData(
//         entry: json["entry"] == null
//             ? null
//             : QrScanResultDataEntry.fromMap(json["entry"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "entry": entry == null ? null : entry?.toMap(),
//       };
// }

// class QrScanResultDataEntry {
//   QrScanResultDataEntry({
//     this.addresses,
//     this.birthday,
//     this.createdAt,
//     this.deletedAt,
//     this.emails,
//     this.familyName,
//     this.gender,
//     this.genderId,
//     this.givenName,
//     this.id,
//     this.lastActivatedAt,
//     this.lastLoggedAt,
//     this.lastLoggedFailAt,
//     this.locale,
//     this.loginFailedCount,
//     this.middleName,
//     this.name,
//     this.nickname,
//     this.phones,
//     this.picture,
//     this.preferredUsername,
//     this.profile,
//     this.roleId,
//     this.updatedAt,
//     this.username,
//     this.verifyState,
//     this.zoneInfo,
//   });

//   List<dynamic>? addresses;
//   DateTime? birthday;
//   DateTime? createdAt;
//   dynamic deletedAt;
//   List<dynamic>? emails;
//   String? familyName;
//   Gender? gender;
//   int? genderId;
//   String? givenName;
//   String? id;
//   DateTime? lastActivatedAt;
//   dynamic lastLoggedAt;
//   dynamic lastLoggedFailAt;
//   String? locale;
//   int? loginFailedCount;
//   String? middleName;
//   String? name;
//   String? nickname;
//   List<dynamic>? phones;
//   String? picture;
//   String? preferredUsername;
//   String? profile;
//   int? roleId;
//   DateTime? updatedAt;
//   String? username;
//   VerifyState? verifyState;
//   String? zoneInfo;

//   factory QrScanResultDataEntry.fromJson(String str) =>
//       QrScanResultDataEntry.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory QrScanResultDataEntry.fromMap(Map<String, dynamic> json) =>
//       QrScanResultDataEntry(
//         addresses: json["addresses"] == null
//             ? null
//             : List<dynamic>.from(json["addresses"].map((x) => x)),
//         birthday:
//             json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         deletedAt: json["deleted_at"],
//         emails: json["emails"] == null
//             ? null
//             : List<Email>.from(json["emails"].map((x) => x)),
//         familyName: json["family_name"] == null ? null : json["family_name"],
//         gender: json["gender"] == null ? null : Gender.fromMap(json["gender"]),
//         genderId: json["gender_id"] == null ? null : json["gender_id"],
//         givenName: json["given_name"] == null ? null : json["given_name"],
//         id: json["id"] == null ? null : json["id"],
//         lastActivatedAt: json["last_activated_at"] == null
//             ? null
//             : DateTime.parse(json["last_activated_at"]),
//         lastLoggedAt: json["last_logged_at"],
//         lastLoggedFailAt: json["last_logged_fail_at"],
//         locale: json["locale"] == null ? null : json["locale"],
//         loginFailedCount: json["login_failed_count"] == null
//             ? null
//             : json["login_failed_count"],
//         middleName: json["middle_name"] == null ? null : json["middle_name"],
//         name: json["name"] == null ? null : json["name"],
//         nickname: json["nickname"] == null ? null : json["nickname"],
//         phones: json["phones"] == null
//             ? null
//             : List<Phone>.from(json["phones"].map((x) => x)),
//         picture: json["picture"] == null ? null : json["picture"],
//         preferredUsername: json["preferred_username"] == null
//             ? null
//             : json["preferred_username"],
//         profile: json["profile"] == null ? null : json["profile"],
//         roleId: json["role_id"] == null ? null : json["role_id"],
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         username: json["username"] == null ? null : json["username"],
//         verifyState: json["verify_state"] == null
//             ? null
//             : VerifyState.fromMap(json["verify_state"]),
//         zoneInfo: json["zone_info"] == null ? null : json["zone_info"],
//       );

//   Map<String, dynamic> toMap() => {
//         "addresses": addresses == null
//             ? null
//             : List<dynamic>.from((addresses ?? []).map((x) => x)),
//         "birthday": birthday == null ? null : birthday?.toIso8601String(),
//         "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
//         "deleted_at": deletedAt,
//         "emails": emails == null
//             ? null
//             : List<dynamic>.from((emails ?? []).map((x) => x)),
//         "family_name": familyName == null ? null : familyName,
//         "gender": gender == null ? null : gender?.toMap(),
//         "gender_id": genderId == null ? null : genderId,
//         "given_name": givenName == null ? null : givenName,
//         "id": id == null ? null : id,
//         "last_activated_at":
//             lastActivatedAt == null ? null : lastActivatedAt?.toIso8601String(),
//         "last_logged_at": lastLoggedAt,
//         "last_logged_fail_at": lastLoggedFailAt,
//         "locale": locale == null ? null : locale,
//         "login_failed_count":
//             loginFailedCount == null ? null : loginFailedCount,
//         "middle_name": middleName == null ? null : middleName,
//         "name": name == null ? null : name,
//         "nickname": nickname == null ? null : nickname,
//         "phones": phones == null
//             ? null
//             : List<dynamic>.from((phones ?? []).map((x) => x)),
//         "picture": picture == null ? null : picture,
//         "preferred_username":
//             preferredUsername == null ? null : preferredUsername,
//         "profile": profile == null ? null : profile,
//         "role_id": roleId == null ? null : roleId,
//         "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
//         "username": username == null ? null : username,
//         "verify_state": verifyState == null ? null : verifyState?.toMap(),
//         "zone_info": zoneInfo == null ? null : zoneInfo,
//       };
//   static final empty = QrScanResultDataEntry();
// }

// class Gender {
//   Gender({
//     this.description,
//     this.editable,
//     this.id,
//     this.name,
//   });

//   String? description;
//   bool? editable;
//   int? id;
//   String? name;

//   factory Gender.fromJson(String str) => Gender.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Gender.fromMap(Map<String, dynamic> json) => Gender(
//         description: json["description"] == null ? null : json["description"],
//         editable: json["editable"] == null ? null : json["editable"],
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//       );

//   Map<String, dynamic> toMap() => {
//         "description": description == null ? null : description,
//         "editable": editable == null ? null : editable,
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//       };
// }

// class VerifyState {
//   VerifyState({
//     this.currentState,
//     this.kycVerify,
//     this.mailVerify,
//     this.medicalVerify,
//     this.total,
//   });

//   int? currentState;
//   bool? kycVerify;
//   bool? mailVerify;
//   bool? medicalVerify;
//   int? total;

//   factory VerifyState.fromJson(String str) =>
//       VerifyState.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory VerifyState.fromMap(Map<String, dynamic> json) => VerifyState(
//         currentState:
//             json["current_state"] == null ? null : json["current_state"],
//         kycVerify: json["kyc_verify"] == null ? null : json["kyc_verify"],
//         mailVerify: json["mail_verify"] == null ? null : json["mail_verify"],
//         medicalVerify:
//             json["medical_verify"] == null ? null : json["medical_verify"],
//         total: json["total"] == null ? null : json["total"],
//       );

//   Map<String, dynamic> toMap() => {
//         "current_state": currentState == null ? null : currentState,
//         "kyc_verify": kycVerify == null ? null : kycVerify,
//         "mail_verify": mailVerify == null ? null : mailVerify,
//         "medical_verify": medicalVerify == null ? null : medicalVerify,
//         "total": total == null ? null : total,
//       };
// }

// To parse this JSON data, do
//
//     final ekycPutDataResponse = ekycPutDataResponseFromMap(jsonString);

// To parse this JSON data, do
//
//     final qrResponse = qrResponseFromMap(jsonString);

import 'dart:convert';

class QRResponse {
  QRResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.messageCode,
    required this.requestId,
    required this.version,
  });

  int code;
  Data? data;
  String message;
  String messageCode;
  String requestId;
  String version;

  factory QRResponse.fromJson(String str) =>
      QRResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QRResponse.fromMap(Map<String, dynamic> json) => QRResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
        message: json["message"] == null ? null : json["message"],
        messageCode: json["message_code"] == null ? null : json["message_code"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        version: json["version"] == null ? null : json["version"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "data": data == null ? null : data?.toMap(),
        "message": message,
        "message_code": messageCode,
        "request_id": requestId,
        "version": version,
      };
}

class Data {
  Data({
    required this.entry,
  });

  QrScanResultDataEntry? entry;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        entry: json["entry"] == null
            ? null
            : QrScanResultDataEntry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class QrScanResultDataEntry {
  QrScanResultDataEntry({
    required this.addresses,
    required this.birthday,
    required this.createdAt,
    required this.deletedAt,
    required this.econtractId,
    required this.emails,
    required this.familyName,
    required this.gender,
    required this.genderId,
    required this.givenName,
    required this.id,
    required this.lastActivatedAt,
    required this.lastLoggedAt,
    required this.lastLoggedFailAt,
    required this.locale,
    required this.loginFailedCount,
    required this.middleName,
    required this.name,
    required this.nickname,
    required this.phones,
    required this.picture,
    required this.practicingCertificates,
    required this.preferredUsername,
    required this.profile,
    required this.roleId,
    required this.updatedAt,
    required this.username,
    required this.verifyState,
    required this.zoneInfo,
  });

  List<dynamic>? addresses;
  DateTime? birthday;
  DateTime? createdAt;
  DateTime? deletedAt;
  String? econtractId;
  List<Email>? emails;
  String? familyName;
  Gender? gender;
  int? genderId;
  String? givenName;
  String? id;
  DateTime? lastActivatedAt;
  DateTime? lastLoggedAt;
  DateTime? lastLoggedFailAt;
  String? locale;
  int? loginFailedCount;
  String? middleName;
  String? name;
  String? nickname;
  List<Email>? phones;
  String? picture;
  List<PracticingCertificate>? practicingCertificates;
  String? preferredUsername;
  String? profile;
  int? roleId;
  DateTime? updatedAt;
  String? username;
  VerifyState verifyState;
  String? zoneInfo;

  factory QrScanResultDataEntry.fromJson(String str) =>
      QrScanResultDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrScanResultDataEntry.fromMap(Map<String, dynamic> json) =>
      QrScanResultDataEntry(
        addresses: json["addresses"] == null
            ? null
            : List<dynamic>.from((json["addresses"] ?? []).map((x) => x)),
        birthday: DateTime.parse(json["birthday"]),
        createdAt: DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"],
        econtractId: json["econtract_id"] == null ? null : json["econtract_id"],
        emails: List<Email>.from(json["emails"].map((x) => Email.fromMap(x))),
        familyName: json["family_name"] == null ? null : json["family_name"],
        gender: Gender.fromMap(json["gender"]),
        genderId: json["gender_id"] == null ? null : json["gender_id"],
        givenName: json["given_name"] == null ? null : json["given_name"],
        id: json["id"] == null ? null : json["id"],
        lastActivatedAt: DateTime.parse(json["last_activated_at"]),
        lastLoggedAt: json["last_logged_at"],
        lastLoggedFailAt: json["last_logged_fail_at"],
        locale: json["locale"] == null ? null : json["locale"],
        loginFailedCount: json["login_failed_count"] == null
            ? null
            : json["login_failed_count"],
        middleName: json["middle_name"] == null ? null : json["middle_name"],
        name: json["name"] == null ? null : json["name"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        phones: List<Email>.from(json["phones"].map((x) => Email.fromMap(x))),
        picture: json["picture"] == null ? null : json["picture"],
        practicingCertificates: json["practicing_certificates"] == null
            ? null
            : List<PracticingCertificate>.from(json["practicing_certificates"]
                .map((x) => PracticingCertificate.fromMap(x))),
        preferredUsername: json["preferred_username"] == null
            ? null
            : json["preferred_username"],
        profile: json["profile"] == null ? null : json["profile"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"] == null ? null : json["username"],
        verifyState: VerifyState.fromMap(json["verify_state"]),
        zoneInfo: json["zone_info"] == null ? null : json["zone_info"],
      );

  Map<String, dynamic> toMap() => {
        "addresses": addresses == null
            ? null
            : List<dynamic>.from((addresses ?? []).map((x) => x)),
        "birthday": birthday == null ? null : birthday?.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "deleted_at": deletedAt == null ? null : deletedAt?.toIso8601String(),
        "econtract_id": econtractId == null ? null : econtractId,
        "emails": emails == null
            ? null
            : List<dynamic>.from((emails ?? []).map((x) => x.toMap())),
        "family_name": familyName == null ? null : familyName,
        "gender": gender == null ? null : gender?.toMap(),
        "gender_id": genderId == null ? null : genderId,
        "given_name": givenName == null ? null : givenName,
        "id": id == null ? null : id,
        "last_activated_at":
            lastActivatedAt == null ? null : lastActivatedAt?.toIso8601String(),
        "last_logged_at":
            lastLoggedAt == null ? null : lastLoggedAt?.toIso8601String(),
        "last_logged_fail_at": lastLoggedFailAt == null
            ? null
            : lastLoggedFailAt?.toIso8601String(),
        "locale": locale == null ? null : locale,
        "login_failed_count":
            loginFailedCount == null ? null : loginFailedCount,
        "middle_name": middleName == null ? null : middleName,
        "name": name == null ? null : name,
        "nickname": nickname == null ? null : nickname,
        "phones": phones == null
            ? null
            : List<dynamic>.from((phones ?? []).map((x) => x.toMap())),
        "picture": picture == null ? null : picture,
        "practicing_certificates": practicingCertificates == null
            ? null
            : List<dynamic>.from(
                (practicingCertificates ?? []).map((x) => x.toMap())),
        "preferred_username":
            preferredUsername == null ? null : preferredUsername,
        "profile": profile == null ? null : profile,
        "role_id": roleId == null ? null : roleId,
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "username": username == null ? null : username,
        "verify_state": verifyState.toMap(),
        "zone_info": zoneInfo == null ? null : zoneInfo,
      };
}

class Email {
  Email({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.isDefault,
    required this.isVerify,
    required this.name,
    required this.priority,
    required this.updatedAt,
    required this.userId,
    required this.value,
    required this.countryId,
    required this.fullNumber,
  });

  DateTime? createdAt;
  String? description;
  int? id;
  bool? isDefault;
  bool? isVerify;
  String? name;
  int? priority;
  DateTime? updatedAt;
  String? userId;
  String? value;
  int? countryId;
  String? fullNumber;

  factory Email.fromJson(String str) => Email.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Email.fromMap(Map<String, dynamic> json) => Email(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        description: json["description"] == null ? null : json["description"],
        id: json["id"] == null ? null : json["id"],
        isDefault: json["is_default"] == null ? null : json["is_default"],
        isVerify: json["is_verify"] == null ? null : json["is_verify"],
        name: json["name"] == null ? null : json["name"],
        priority: json["priority"] == null ? null : json["priority"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userId: json["user_id"] == null ? null : json["user_id"],
        value: json["value"] == null ? null : json["value"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        fullNumber: json["full_number"] == null ? null : json["full_number"],
      );

  Map<String, dynamic> toMap() => {
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "description": description == null ? null : description,
        "id": id == null ? null : id,
        "is_default": isDefault == null ? null : isDefault,
        "is_verify": isVerify == null ? null : isVerify,
        "name": name == null ? null : name,
        "priority": priority == null ? null : priority,
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "user_id": userId == null ? null : userId,
        "value": value == null ? null : value,
        "country_id": countryId == null ? null : countryId,
        "full_number": fullNumber == null ? null : fullNumber,
      };
}

class Gender {
  Gender({
    required this.description,
    required this.editable,
    required this.id,
    required this.name,
  });

  String? description;
  bool? editable;
  int? id;
  String? name;

  factory Gender.fromJson(String str) => Gender.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Gender.fromMap(Map<String, dynamic> json) => Gender(
        description: json["description"] == null ? null : json["description"],
        editable: json["editable"] == null ? null : json["editable"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "description": description == null ? null : description,
        "editable": editable == null ? null : editable,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class PracticingCertificate {
  PracticingCertificate({
    required this.certificateNumber,
    required this.code,
    required this.createdAt,
    required this.deletedAt,
    required this.expiredAt,
    required this.id,
    required this.isPrimary,
    required this.issuedAt,
    required this.issuedPlace,
    required this.issuedPlaceId,
    required this.practicingStatusId,
    required this.signator,
    required this.signatorPosition,
    required this.updatedAt,
    required this.userId,
  });

  String? certificateNumber;
  String? code;
  DateTime? createdAt;
  DateTime? deletedAt;
  DateTime? expiredAt;
  int? id;
  bool? isPrimary;
  DateTime? issuedAt;
  IssuedPlace? issuedPlace;
  int? issuedPlaceId;
  int? practicingStatusId;
  String? signator;
  String? signatorPosition;
  DateTime? updatedAt;
  String? userId;

  factory PracticingCertificate.fromJson(String str) =>
      PracticingCertificate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PracticingCertificate.fromMap(Map<String, dynamic> json) =>
      PracticingCertificate(
        certificateNumber: json["certificate_number"] == null
            ? null
            : json["certificate_number"],
        code: json["code"] == null ? null : json["code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"],
        expiredAt: json["expired_at"] == null
            ? null
            : DateTime.parse(json["expired_at"]),
        id: json["id"] == null ? null : json["id"],
        isPrimary: json["is_primary"] == null ? null : json["is_primary"],
        issuedAt: json["issued_at"] == null
            ? null
            : DateTime.parse(json["issued_at"]),
        issuedPlace: json["issued_place"] == null
            ? null
            : IssuedPlace.fromMap(json["issued_place"]),
        issuedPlaceId:
            json["issued_place_id"] == null ? null : json["issued_place_id"],
        practicingStatusId: json["practicing_status_id"] == null
            ? null
            : json["practicing_status_id"],
        signator: json["signator"] == null ? null : json["signator"],
        signatorPosition: json["signator_position"] == null
            ? null
            : json["signator_position"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userId: json["user_id"] == null ? null : json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "certificate_number":
            certificateNumber == null ? null : certificateNumber,
        "code": code == null ? null : code,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "deleted_at": deletedAt == null ? null : deletedAt?.toIso8601String(),
        "expired_at": expiredAt == null ? null : expiredAt?.toIso8601String(),
        "id": id == null ? null : id,
        "is_primary": isPrimary == null ? null : isPrimary,
        "issued_at": issuedAt == null ? null : issuedAt?.toIso8601String(),
        "issued_place": issuedPlace == null ? null : issuedPlace?.toMap(),
        "issued_place_id": issuedPlaceId == null ? null : issuedPlaceId,
        "practicing_status_id":
            practicingStatusId == null ? null : practicingStatusId,
        "signator": signator == null ? null : signator,
        "signator_position": signatorPosition == null ? null : signatorPosition,
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "user_id": userId == null ? null : userId,
      };
}

class IssuedPlace {
  IssuedPlace({
    required this.code,
    required this.color,
    required this.country,
    required this.countryId,
    required this.govId,
    required this.id,
    required this.isActive,
    required this.name,
    required this.practicingCertificateCode,
    required this.priority,
    required this.svgPath,
  });

  String? code;
  String? color;
  Country? country;
  int? countryId;
  int? govId;
  int? id;
  bool? isActive;
  String? name;
  String? practicingCertificateCode;
  int? priority;
  String? svgPath;

  factory IssuedPlace.fromJson(String str) =>
      IssuedPlace.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IssuedPlace.fromMap(Map<String, dynamic> json) => IssuedPlace(
        code: json["code"] == null ? null : json["code"],
        color: json["color"] == null ? null : json["color"],
        country:
            json["country"] == null ? null : Country.fromMap(json["country"]),
        countryId: json["country_id"] == null ? null : json["country_id"],
        govId: json["gov_id"] == null ? null : json["gov_id"],
        id: json["id"] == null ? null : json["id"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        name: json["name"] == null ? null : json["name"],
        practicingCertificateCode: json["practicing_certificate_code"] == null
            ? null
            : json["practicing_certificate_code"],
        priority: json["priority"] == null ? null : json["priority"],
        svgPath: json["svg_path"] == null ? null : json["svg_path"],
      );

  Map<String, dynamic> toMap() => {
        "code": code == null ? null : code,
        "color": color == null ? null : color,
        "country": country == null ? null : country?.toMap(),
        "country_id": countryId == null ? null : countryId,
        "gov_id": govId == null ? null : govId,
        "id": id == null ? null : id,
        "is_active": isActive == null ? null : isActive,
        "name": name == null ? null : name,
        "practicing_certificate_code": practicingCertificateCode == null
            ? null
            : practicingCertificateCode,
        "priority": priority == null ? null : priority,
        "svg_path": svgPath == null ? null : svgPath,
      };
}

class Country {
  Country({
    required this.alias,
    required this.code,
    required this.id,
    required this.name,
    required this.phoneCode,
    required this.priority,
  });

  String? alias;
  String? code;
  int? id;
  String? name;
  String? phoneCode;
  int? priority;

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        alias: json["alias"] == null ? null : json["alias"],
        code: json["code"] == null ? null : json["code"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phoneCode: json["phone_code"] == null ? null : json["phone_code"],
        priority: json["priority"] == null ? null : json["priority"],
      );

  Map<String, dynamic> toMap() => {
        "alias": alias == null ? null : alias,
        "code": code == null ? null : code,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone_code": phoneCode == null ? null : phoneCode,
        "priority": priority == null ? null : priority,
      };
}

class VerifyState {
  VerifyState({
    required this.currentState,
    required this.kycVerify,
    required this.mailVerify,
    required this.medicalVerify,
    required this.total,
  });

  int currentState;
  bool kycVerify;
  bool mailVerify;
  bool medicalVerify;
  int total;

  factory VerifyState.fromJson(String str) =>
      VerifyState.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerifyState.fromMap(Map<String, dynamic> json) => VerifyState(
        currentState:
            json["current_state"] == null ? null : json["current_state"],
        kycVerify: json["kyc_verify"] == null ? null : json["kyc_verify"],
        mailVerify: json["mail_verify"] == null ? null : json["mail_verify"],
        medicalVerify:
            json["medical_verify"] == null ? null : json["medical_verify"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_state": currentState,
        "kyc_verify": kycVerify,
        "mail_verify": mailVerify,
        "medical_verify": medicalVerify,
        "total": total,
      };
}
