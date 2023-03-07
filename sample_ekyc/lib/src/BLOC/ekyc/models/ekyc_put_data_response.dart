import 'dart:convert';

class EkycPutDataResponse {
  EkycPutDataResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.messageCode,
    required this.requestId,
    required this.version,
  });

  int? code;
  EkycPutDataResponseData? data;
  String? message;
  String? messageCode;
  String? requestId;
  String? version;

  factory EkycPutDataResponse.fromJson(String str) =>
      EkycPutDataResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EkycPutDataResponse.fromMap(Map<String, dynamic> json) =>
      EkycPutDataResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null
            ? null
            : EkycPutDataResponseData.fromMap(json["data"]),
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

class EkycPutDataResponseData {
  EkycPutDataResponseData({
    required this.entry,
  });

  EkycPutDataResponseDataEntry? entry;

  factory EkycPutDataResponseData.fromJson(String str) =>
      EkycPutDataResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EkycPutDataResponseData.fromMap(Map<String, dynamic> json) =>
      EkycPutDataResponseData(
        entry: json["entry"] == null
            ? null
            : EkycPutDataResponseDataEntry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class EkycPutDataResponseDataEntry {
  EkycPutDataResponseDataEntry({
    required this.userId,
    required this.requestId,
    required this.frontUrl,
    required this.backUrl,
    required this.faceUrl,
    required this.type,
    required this.name,
    required this.value,
    required this.gender,
    required this.address,
    required this.countryId,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.birthday,
    required this.ethnic,
    required this.liveness,
    required this.expiredAt,
    required this.characteristic,
    required this.issuedAt,
    required this.issuedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.province,
    required this.district,
    required this.country,
  });

  String? userId;
  String? requestId;
  String? frontUrl;
  String? backUrl;
  String? faceUrl;
  String? type;
  String? name;
  String? value;
  String? gender;
  String? address;
  int? countryId;
  int? provinceId;
  int? districtId;
  int? wardId;
  String? birthday;
  String? ethnic;
  bool? liveness;
  String? expiredAt;
  String? characteristic;
  String? issuedAt;
  String? issuedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Province? province;
  District? district;
  Country? country;

  factory EkycPutDataResponseDataEntry.fromJson(String str) =>
      EkycPutDataResponseDataEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EkycPutDataResponseDataEntry.fromMap(Map<String, dynamic> json) =>
      EkycPutDataResponseDataEntry(
        userId: json["user_id"] == null ? null : json["user_id"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        frontUrl: json["front_url"] == null ? null : json["front_url"],
        backUrl: json["back_url"] == null ? null : json["back_url"],
        faceUrl: json["face_url"] == null ? null : json["face_url"],
        type: json["type"] == null ? null : json["type"],
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
        gender: json["gender"] == null ? null : json["gender"],
        address: json["address"] == null ? null : json["address"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        districtId: json["district_id"] == null ? null : json["district_id"],
        wardId: json["ward_id"] == null ? null : json["ward_id"],
        birthday: json["birthday"] == null ? null : json["birthday"],
        ethnic: json["ethnic"] == null ? null : json["ethnic"],
        liveness: json["liveness"] == null ? null : json["liveness"],
        expiredAt: json["expired_at"] == null ? null : json["expired_at"],
        characteristic:
            json["characteristic"] == null ? null : json["characteristic"],
        issuedAt: json["issued_at"] == null ? null : json["issued_at"],
        issuedBy: json["issued_by"] == null ? null : json["issued_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        province: json["province"] == null
            ? null
            : Province.fromMap(json["province"]),
        district: json["district"] == null
            ? null
            : District.fromMap(json["district"]),
        country:
            json["country"] == null ? null : Country.fromMap(json["country"]),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId == null ? null : userId,
        "request_id": requestId == null ? null : requestId,
        "front_url": frontUrl == null ? null : frontUrl,
        "back_url": backUrl == null ? null : backUrl,
        "face_url": faceUrl == null ? null : faceUrl,
        "type": type == null ? null : type,
        "name": name == null ? null : name,
        "value": value == null ? null : value,
        "gender": gender == null ? null : gender,
        "address": address == null ? null : address,
        "country_id": countryId == null ? null : countryId,
        "province_id": provinceId == null ? null : provinceId,
        "district_id": districtId == null ? null : districtId,
        "ward_id": wardId == null ? null : wardId,
        "birthday": birthday == null ? null : birthday,
        "ethnic": ethnic == null ? null : ethnic,
        "liveness": liveness == null ? null : liveness,
        "expired_at": expiredAt == null ? null : expiredAt,
        "characteristic": characteristic == null ? null : characteristic,
        "issued_at": issuedAt == null ? null : issuedAt,
        "issued_by": issuedBy == null ? null : issuedBy,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "user": user == null ? null : user?.toMap(),
        "province": province == null ? null : province?.toMap(),
        "district": district == null ? null : district?.toMap(),
        "country": country == null ? null : country?.toMap(),
      };
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.alias,
    required this.code,
    required this.phoneCode,
    required this.priority,
  });

  int? id;
  String? name;
  String? alias;
  String? code;
  String? phoneCode;
  int? priority;

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        alias: json["alias"] == null ? null : json["alias"],
        code: json["code"] == null ? null : json["code"],
        phoneCode: json["phone_code"] == null ? null : json["phone_code"],
        priority: json["priority"] == null ? null : json["priority"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "alias": alias == null ? null : alias,
        "code": code == null ? null : code,
        "phone_code": phoneCode == null ? null : phoneCode,
        "priority": priority == null ? null : priority,
      };
}

class District {
  District({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.province,
  });

  int? id;
  int? provinceId;
  String? name;
  String? code;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  Province? province;

  factory District.fromJson(String str) => District.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory District.fromMap(Map<String, dynamic> json) => District(
        id: json["id"] == null ? null : json["id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        province: json["province"] == null
            ? null
            : Province.fromMap(json["province"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "province_id": provinceId == null ? null : provinceId,
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "deleted_at": deletedAt == null ? null : deletedAt?.toIso8601String(),
        "province": province == null ? null : province?.toMap(),
      };
}

class Province {
  Province({
    required this.id,
    required this.countryId,
    required this.govId,
    required this.name,
    required this.code,
    required this.svgPath,
    required this.color,
    required this.priority,
    required this.isActive,
    required this.practicingCertificateCode,
    required this.country,
  });

  int? id;
  int? countryId;
  int? govId;
  String? name;
  String? code;
  String? svgPath;
  String? color;
  int? priority;
  bool? isActive;
  String? practicingCertificateCode;
  Country? country;

  factory Province.fromJson(String str) => Province.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Province.fromMap(Map<String, dynamic> json) => Province(
        id: json["id"] == null ? null : json["id"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        govId: json["gov_id"] == null ? null : json["gov_id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        svgPath: json["svg_path"] == null ? null : json["svg_path"],
        color: json["color"] == null ? null : json["color"],
        priority: json["priority"] == null ? null : json["priority"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        practicingCertificateCode: json["practicing_certificate_code"] == null
            ? null
            : json["practicing_certificate_code"],
        country:
            json["country"] == null ? null : Country.fromMap(json["country"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "country_id": countryId == null ? null : countryId,
        "gov_id": govId == null ? null : govId,
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "svg_path": svgPath == null ? null : svgPath,
        "color": color == null ? null : color,
        "priority": priority == null ? null : priority,
        "is_active": isActive == null ? null : isActive,
        "practicing_certificate_code": practicingCertificateCode == null
            ? null
            : practicingCertificateCode,
        "country": country == null ? null : country?.toMap(),
      };
}

class User {
  User({
    required this.id,
    required this.econtractId,
    required this.name,
    required this.username,
    required this.givenName,
    required this.familyName,
    required this.middleName,
    required this.nickname,
    required this.preferredUsername,
    required this.profile,
    required this.picture,
    required this.birthday,
    required this.zoneInfo,
    required this.locale,
    required this.lastActivatedAt,
    required this.lastLoggedFailAt,
    required this.loginFailedCount,
    required this.lastLoggedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.genderId,
    required this.roleId,
    required this.phones,
    required this.emails,
    required this.addresses,
    required this.verifyState,
  });

  String? id;
  String? econtractId;
  String? name;
  String? username;
  String? givenName;
  String? familyName;
  String? middleName;
  String? nickname;
  String? preferredUsername;
  String? profile;
  String? picture;
  DateTime? birthday;
  String? zoneInfo;
  String? locale;
  DateTime? lastActivatedAt;
  DateTime? lastLoggedFailAt;
  int? loginFailedCount;
  DateTime? lastLoggedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int? genderId;
  int? roleId;
  dynamic phones;
  dynamic emails;
  dynamic addresses;
  VerifyState? verifyState;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        econtractId: json["econtract_id"] == null ? null : json["econtract_id"],
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        givenName: json["given_name"] == null ? null : json["given_name"],
        familyName: json["family_name"] == null ? null : json["family_name"],
        middleName: json["middle_name"] == null ? null : json["middle_name"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        preferredUsername: json["preferred_username"] == null
            ? null
            : json["preferred_username"],
        profile: json["profile"] == null ? null : json["profile"],
        picture: json["picture"] == null ? null : json["picture"],
        birthday: json["birthday"],
        zoneInfo: json["zone_info"] == null ? null : json["zone_info"],
        locale: json["locale"] == null ? null : json["locale"],
        lastActivatedAt: json["last_activated_at"],
        lastLoggedFailAt: json["last_logged_fail_at"],
        loginFailedCount: json["login_failed_count"] == null
            ? null
            : json["login_failed_count"],
        lastLoggedAt: json["last_logged_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        genderId: json["gender_id"] == null ? null : json["gender_id"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        phones: json["phones"],
        emails: json["emails"],
        addresses: json["addresses"],
        verifyState: json["verify_state"] == null
            ? null
            : VerifyState.fromMap(json["verify_state"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "econtract_id": econtractId == null ? null : econtractId,
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "given_name": givenName == null ? null : givenName,
        "family_name": familyName == null ? null : familyName,
        "middle_name": middleName == null ? null : middleName,
        "nickname": nickname == null ? null : nickname,
        "preferred_username":
            preferredUsername == null ? null : preferredUsername,
        "profile": profile == null ? null : profile,
        "picture": picture == null ? null : picture,
        "birthday": birthday,
        "zone_info": zoneInfo == null ? null : zoneInfo,
        "locale": locale == null ? null : locale,
        "last_activated_at":
            lastActivatedAt == null ? null : lastActivatedAt?.toIso8601String(),
        "last_logged_fail_at": lastLoggedFailAt == null
            ? null
            : lastLoggedFailAt?.toIso8601String(),
        "login_failed_count":
            loginFailedCount == null ? null : loginFailedCount,
        "last_logged_at":
            lastLoggedAt == null ? null : lastLoggedAt?.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "deleted_at": deletedAt == null ? null : deletedAt?.toIso8601String(),
        "gender_id": genderId == null ? null : genderId,
        "role_id": roleId == null ? null : roleId,
        "phones": phones,
        "emails": emails,
        "addresses": addresses,
        "verify_state": verifyState == null ? null : verifyState?.toMap(),
      };
}

class VerifyState {
  VerifyState({
    required this.total,
    required this.currentState,
    required this.mailVerify,
    required this.kycVerify,
    required this.medicalVerify,
  });

  int? total;
  int? currentState;
  bool? mailVerify;
  bool? kycVerify;
  bool? medicalVerify;

  factory VerifyState.fromJson(String str) =>
      VerifyState.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VerifyState.fromMap(Map<String, dynamic> json) => VerifyState(
        total: json["total"] == null ? null : json["total"],
        currentState:
            json["current_state"] == null ? null : json["current_state"],
        mailVerify: json["mail_verify"] == null ? null : json["mail_verify"],
        kycVerify: json["kyc_verify"] == null ? null : json["kyc_verify"],
        medicalVerify:
            json["medical_verify"] == null ? null : json["medical_verify"],
      );

  Map<String, dynamic> toMap() => {
        "total": total == null ? null : total,
        "current_state": currentState == null ? null : currentState,
        "mail_verify": mailVerify == null ? null : mailVerify,
        "kyc_verify": kycVerify == null ? null : kycVerify,
        "medical_verify": medicalVerify == null ? null : medicalVerify,
      };
}
