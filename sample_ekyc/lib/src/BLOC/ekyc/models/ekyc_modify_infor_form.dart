import 'dart:convert';

class EkycModifyFormModel {
  EkycModifyFormModel({
    required this.userId,
    required this.requestId,
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
  });

  final String? userId;
  final String? requestId;
  final String? type;
  final String? name;
  final String? value;
  final String? gender;
  final String? address;
  final int? countryId;
  final int? provinceId;
  final int? districtId;
  final int? wardId;
  final String? birthday;
  final String? ethnic;
  final bool? liveness;
  final String? expiredAt;
  final String? characteristic;
  final String? issuedAt;
  final String? issuedBy;

  factory EkycModifyFormModel.fromJson(String str) =>
      EkycModifyFormModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EkycModifyFormModel.fromMap(Map<String, dynamic> json) =>
      EkycModifyFormModel(
        userId: json["user_id"] == null ? null : json["user_id"],
        requestId: json["request_id"] == null ? null : json["request_id"],
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
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "request_id": requestId,
        "type": type,
        "name": name,
        "value": value,
        "gender": gender,
        "address": address,
        "country_id": countryId,
        "province_id": provinceId,
        "district_id": districtId,
        "ward_id": wardId,
        "birthday": birthday,
        "ethnic": ethnic,
        "liveness": liveness,
        "expired_at": expiredAt,
        "characteristic": characteristic,
        "issued_at": issuedAt,
        "issued_by": issuedBy,
      };
}
