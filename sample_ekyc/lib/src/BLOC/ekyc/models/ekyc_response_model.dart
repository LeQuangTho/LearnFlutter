import 'dart:convert';

class EkycOCRResponse {
  EkycOCRResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.messageCode,
    required this.requestId,
    required this.version,
  });

  final int? code;
  final Data? data;
  final String? message;
  final String? messageCode;
  final String? requestId;
  final String? version;

  factory EkycOCRResponse.fromJson(String str) =>
      EkycOCRResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EkycOCRResponse.fromMap(Map<String, dynamic> json) => EkycOCRResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
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

class Data {
  Data({
    required this.entry,
  });

  final Entry? entry;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        entry: json["entry"] == null ? null : Entry.fromMap(json["entry"]),
      );

  Map<String, dynamic> toMap() => {
        "entry": entry == null ? null : entry?.toMap(),
      };
}

class Entry {
  Entry({
    required this.output,
    required this.time,
    required this.apiVersion,
    required this.mlchainVersion,
    required this.requestId,
  });

  final List<Output>? output;
  final double? time;
  final String? apiVersion;
  final String? mlchainVersion;
  final String? requestId;

  factory Entry.fromJson(String str) => Entry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Entry.fromMap(Map<String, dynamic> json) => Entry(
        output: json["output"] == null
            ? null
            : List<Output>.from(json["output"].map((x) => Output.fromMap(x))),
        time: json["time"] == null ? null : json["time"].toDouble(),
        apiVersion: json["api_version"] == null ? null : json["api_version"],
        mlchainVersion:
            json["mlchain_version"] == null ? null : json["mlchain_version"],
        requestId: json["request_id"] == null ? null : json["request_id"],
      );

  Map<String, dynamic> toMap() => {
        "output": output == null
            ? null
            : List<dynamic>.from((output ?? []).map((x) => x.toMap())),
        "time": time == null ? null : time,
        "api_version": apiVersion == null ? null : apiVersion,
        "mlchain_version": mlchainVersion == null ? null : mlchainVersion,
        "request_id": requestId == null ? null : requestId,
      };
}

class Output {
  Output({
    required this.id,
    required this.hoTen,
    required this.ngaySinh,
    required this.nguyenQuan,
    required this.hoKhauThuongTru,
    required this.className,
    required this.liveness,
    required this.danToc,
    required this.ngayHetHan,
    required this.diHinh,
    required this.ngayCap,
    required this.noiCap,
    required this.isMatched,
  });

  final Details? id;
  final Details? hoTen;
  final Details? ngaySinh;
  final Details? nguyenQuan;
  final Details? hoKhauThuongTru;
  final ClassName? className;
  final Liveness? liveness;
  final Details? danToc;
  final Details? ngayHetHan;
  final Details? diHinh;
  final Details? ngayCap;
  final Details? noiCap;
  final IsMatched? isMatched;

  factory Output.fromJson(String str) => Output.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Output.fromMap(Map<String, dynamic> json) => Output(
        id: json["id"] == null ? null : Details.fromMap(json["id"]),
        hoTen: json["ho_ten"] == null ? null : Details.fromMap(json["ho_ten"]),
        ngaySinh: json["ngay_sinh"] == null
            ? null
            : Details.fromMap(json["ngay_sinh"]),
        nguyenQuan: json["nguyen_quan"] == null
            ? null
            : Details.fromMap(json["nguyen_quan"]),
        hoKhauThuongTru: json["ho_khau_thuong_tru"] == null
            ? null
            : Details.fromMap(json["ho_khau_thuong_tru"]),
        className: json["class_name"] == null
            ? null
            : ClassName.fromMap(json["class_name"]),
        liveness: json["liveness"] == null
            ? null
            : Liveness.fromMap(json["liveness"]),
        danToc:
            json["dan_toc"] == null ? null : Details.fromMap(json["dan_toc"]),
        ngayHetHan: json["ngay_het_han"] == null
            ? null
            : Details.fromMap(json["ngay_het_han"]),
        diHinh:
            json["di_hinh"] == null ? null : Details.fromMap(json["di_hinh"]),
        ngayCap:
            json["ngay_cap"] == null ? null : Details.fromMap(json["ngay_cap"]),
        noiCap:
            json["noi_cap"] == null ? null : Details.fromMap(json["noi_cap"]),
        isMatched: json["is_matched"] == null
            ? null
            : IsMatched.fromMap(json["is_matched"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id?.toMap(),
        "ho_ten": hoTen == null ? null : hoTen?.toMap(),
        "ngay_sinh": ngaySinh == null ? null : ngaySinh?.toMap(),
        "nguyen_quan": nguyenQuan == null ? null : nguyenQuan?.toMap(),
        "ho_khau_thuong_tru":
            hoKhauThuongTru == null ? null : hoKhauThuongTru?.toMap(),
        "class_name": className == null ? null : className?.toMap(),
        "liveness": liveness == null ? null : liveness?.toMap(),
        "dan_toc": danToc == null ? null : danToc?.toMap(),
        "ngay_het_han": ngayHetHan == null ? null : ngayHetHan?.toMap(),
        "di_hinh": diHinh == null ? null : diHinh?.toMap(),
        "ngay_cap": ngayCap == null ? null : ngayCap?.toMap(),
        "noi_cap": noiCap == null ? null : noiCap?.toMap(),
        "is_matched": isMatched == null ? null : isMatched?.toMap(),
      };
}

class ClassName {
  ClassName({
    required this.value,
    required this.confidence,
    required this.normalized,
  });

  final String value;
  final int confidence;
  final ClassNameNormalized? normalized;

  factory ClassName.fromJson(String str) => ClassName.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClassName.fromMap(Map<String, dynamic> json) => ClassName(
        value: json["value"] == null ? null : json["value"],
        confidence: json["confidence"] == null ? null : json["confidence"],
        normalized: json["normalized"] == null
            ? null
            : ClassNameNormalized.fromMap(json["normalized"]),
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "confidence": confidence,
        "normalized": normalized == null ? null : normalized?.toMap(),
      };
}

class ClassNameNormalized {
  ClassNameNormalized({
    required this.value,
    required this.code,
  });

  final int value;
  final String code;

  factory ClassNameNormalized.fromJson(String str) =>
      ClassNameNormalized.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClassNameNormalized.fromMap(Map<String, dynamic> json) =>
      ClassNameNormalized(
        value: json["value"] == null ? null : json["value"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "code": code,
      };
}

class Details {
  Details({
    required this.value,
    required this.valueUnidecode,
    required this.confidence,
    required this.normalized,
    required this.validate,
    required this.isValid,
  });

  final String value;
  final String valueUnidecode;
  final double confidence;
  final DanTocNormalized? normalized;
  final Validate? validate;
  final bool? isValid;

  factory Details.fromJson(String str) => Details.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Details.fromMap(Map<String, dynamic> json) => Details(
        value: json["value"] == null ? null : json["value"],
        valueUnidecode:
            json["value_unidecode"] == null ? null : json["value_unidecode"],
        confidence:
            json["confidence"] == null ? null : json["confidence"].toDouble(),
        normalized: json["normalized"] == null
            ? null
            : DanTocNormalized.fromMap(json["normalized"]),
        validate: json["validate"] == null
            ? null
            : Validate.fromMap(json["validate"]),
        isValid: json["is_valid"] == null ? null : json["is_valid"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "value_unidecode": valueUnidecode,
        "confidence": confidence,
        "normalized": normalized == null ? null : normalized?.toMap(),
        "validate": validate == null ? null : validate?.toMap(),
        "is_valid": isValid,
      };
}

class DanTocNormalized {
  DanTocNormalized({
    required this.value,
    required this.valueUnidecode,
    required this.tinh,
    required this.huyen,
    required this.xa,
    required this.year,
    required this.month,
    required this.day,
  });

  final String value;
  final String valueUnidecode;
  final Huyen? tinh;
  final Huyen? huyen;
  final Huyen? xa;
  final Day? year;
  final Day? month;
  final Day? day;

  factory DanTocNormalized.fromJson(String str) =>
      DanTocNormalized.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DanTocNormalized.fromMap(Map<String, dynamic> json) =>
      DanTocNormalized(
        value: json["value"] == null ? null : json["value"],
        valueUnidecode:
            json["value_unidecode"] == null ? null : json["value_unidecode"],
        tinh: json["tinh"] == null ? null : Huyen.fromMap(json["tinh"]),
        huyen: json["huyen"] == null ? null : Huyen.fromMap(json["huyen"]),
        xa: json["xa"] == null ? null : Huyen.fromMap(json["xa"]),
        year: json["year"] == null ? null : Day.fromMap(json["year"]),
        month: json["month"] == null ? null : Day.fromMap(json["month"]),
        day: json["day"] == null ? null : Day.fromMap(json["day"]),
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "value_unidecode": valueUnidecode,
        "tinh": tinh == null ? null : tinh?.toMap(),
        "huyen": huyen == null ? null : huyen?.toMap(),
        "xa": xa == null ? null : xa?.toMap(),
        "year": year == null ? null : year?.toMap(),
        "month": month == null ? null : month?.toMap(),
        "day": day == null ? null : day?.toMap(),
      };
}

class Day {
  Day({
    required this.value,
  });

  final int value;

  factory Day.fromJson(String str) => Day.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Day.fromMap(Map<String, dynamic> json) => Day(
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
      };
}

class Huyen {
  Huyen({
    required this.value,
    required this.code,
    required this.valueUnidecode,
  });

  final String value;
  final int code;
  final String valueUnidecode;

  factory Huyen.fromJson(String str) => Huyen.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Huyen.fromMap(Map<String, dynamic> json) => Huyen(
        value: json["value"] == null ? null : json["value"],
        code: json["code"] == null ? null : json["code"],
        valueUnidecode:
            json["value_unidecode"] == null ? null : json["value_unidecode"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "code": code,
        "value_unidecode": valueUnidecode,
      };
}

class Validate {
  Validate({
    required this.idCheck,
    required this.idLogic,
    required this.idLogicMessage,
    required this.idconf,
  });

  final String idCheck;
  final int idLogic;
  final String idLogicMessage;
  final List<double>? idconf;

  factory Validate.fromJson(String str) => Validate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Validate.fromMap(Map<String, dynamic> json) => Validate(
        idCheck: json["id_check"] == null ? null : json["id_check"],
        idLogic: json["id_logic"] == null ? null : json["id_logic"],
        idLogicMessage:
            json["id_logic_message"] == null ? null : json["id_logic_message"],
        idconf: json["idconf"] == null
            ? null
            : List<double>.from(json["idconf"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "id_check": idCheck,
        "id_logic": idLogic,
        "id_logic_message": idLogicMessage,
        "idconf": idconf == null
            ? null
            : List<dynamic>.from((idconf ?? []).map((x) => x)),
      };
}

class IsMatched {
  IsMatched({
    required this.value,
    required this.confidence,
    required this.similarity,
  });

  final String value;
  final double confidence;
  final double similarity;

  factory IsMatched.fromJson(String str) => IsMatched.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IsMatched.fromMap(Map<String, dynamic> json) => IsMatched(
        value: json["value"] == null ? null : json["value"],
        confidence:
            json["confidence"] == null ? null : json["confidence"].toDouble(),
        similarity:
            json["similarity"] == null ? null : json["similarity"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "confidence": confidence,
        "similarity": similarity,
      };
}

class Liveness {
  Liveness({
    required this.liveness,
  });

  final String liveness;

  factory Liveness.fromJson(String str) => Liveness.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Liveness.fromMap(Map<String, dynamic> json) => Liveness(
        liveness: json["liveness"] == null ? null : json["liveness"],
      );

  Map<String, dynamic> toMap() => {
        "liveness": liveness,
      };
}
