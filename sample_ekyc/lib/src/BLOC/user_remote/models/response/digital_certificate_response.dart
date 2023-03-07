/// code : 200
/// message : "string"
/// traceId : "string"
/// data : [{"id":"3fa85f64-5717-4562-b3fc-2c963f66afa6","userId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","code":"string","alias":"string","createdDate":"2022-11-04T02:21:30.126Z","isDefault":true,"status":true,"subjectDN":"string","userPIN":"string","hasUserPIN":true,"validFrom":"2022-11-04T02:21:30.126Z","validTo":"2022-11-04T02:21:30.126Z","certificateBase64":"string","accountType":1}]

class DigitalCertificateResponse {
  DigitalCertificateResponse({
    num? code,
    String? message,
    String? traceId,
    List<DigitalCertificate>? data,
  }) {
    _code = code;
    _message = message;
    _traceId = traceId;
    _data = data;
  }

  DigitalCertificateResponse.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DigitalCertificate.fromJson(v));
      });
    }
  }
  num? _code;
  String? _message;
  String? _traceId;
  List<DigitalCertificate>? _data;
  DigitalCertificateResponse copyWith({
    num? code,
    String? message,
    String? traceId,
    List<DigitalCertificate>? data,
  }) =>
      DigitalCertificateResponse(
        code: code ?? _code,
        message: message ?? _message,
        traceId: traceId ?? _traceId,
        data: data ?? _data,
      );
  num? get code => _code;
  String? get message => _message;
  String? get traceId => _traceId;
  List<DigitalCertificate>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    map['traceId'] = _traceId;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// userId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// code : "string"
/// alias : "string"
/// createdDate : "2022-11-04T02:21:30.126Z"
/// isDefault : true
/// status : true
/// subjectDN : "string"
/// userPIN : "string"
/// hasUserPIN : true
/// validFrom : "2022-11-04T02:21:30.126Z"
/// validTo : "2022-11-04T02:21:30.126Z"
/// certificateBase64 : "string"
/// accountType : 1

class DigitalCertificate {
  DigitalCertificate({
    String? name,
    String? id,
    String? userId,
    String? code,
    String? alias,
    String? createdDate,
    bool? isDefault,
    bool? status,
    String? subjectDN,
    String? userPIN,
    bool? hasUserPIN,
    String? validFrom,
    String? validTo,
    String? certificateBase64,
    num? accountType,
    bool? selected,
  }) {
    _name = name;
    _id = id;
    _userId = userId;
    _code = code;
    _alias = alias;
    _createdDate = createdDate;
    _isDefault = isDefault;
    _status = status;
    _subjectDN = subjectDN;
    _userPIN = userPIN;
    _hasUserPIN = hasUserPIN;
    _validFrom = validFrom;
    _validTo = validTo;
    _certificateBase64 = certificateBase64;
    _accountType = accountType;
    _selected = selected;
  }

  DigitalCertificate.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
    _userId = json['userId'];
    _code = json['code'];
    _alias = json['alias'];
    _createdDate = json['createdDate'];
    _isDefault = json['isDefault'];
    _status = json['status'];
    _subjectDN = json['subjectDN'];
    _userPIN = json['userPIN'];
    _hasUserPIN = json['hasUserPIN'];
    _validFrom = json['validFrom'];
    _validTo = json['validTo'];
    _certificateBase64 = json['certificateBase64'];
    _accountType = json['accountType'];
    _selected = false;
  }
  String? _name;
  String? _id;
  String? _userId;
  String? _code;
  String? _alias;
  String? _createdDate;
  bool? _isDefault;
  bool? _status;
  String? _subjectDN;
  String? _userPIN;
  bool? _hasUserPIN;
  String? _validFrom;
  String? _validTo;
  String? _certificateBase64;
  bool? _selected;
  num? _accountType;
  DigitalCertificate copyWith(
          {String? name,
          String? id,
          String? userId,
          String? code,
          String? alias,
          String? createdDate,
          bool? isDefault,
          bool? status,
          String? subjectDN,
          String? userPIN,
          bool? hasUserPIN,
          String? validFrom,
          String? validTo,
          String? certificateBase64,
          num? accountType,
          bool? selected}) =>
      DigitalCertificate(
        name: name ?? _name,
        id: id ?? _id,
        userId: userId ?? _userId,
        code: code ?? _code,
        alias: alias ?? _alias,
        createdDate: createdDate ?? _createdDate,
        isDefault: isDefault ?? _isDefault,
        status: status ?? _status,
        subjectDN: subjectDN ?? _subjectDN,
        userPIN: userPIN ?? _userPIN,
        hasUserPIN: hasUserPIN ?? _hasUserPIN,
        validFrom: validFrom ?? _validFrom,
        validTo: validTo ?? _validTo,
        certificateBase64: certificateBase64 ?? _certificateBase64,
        accountType: accountType ?? _accountType,
        selected: selected ?? _selected,
      );
  String? get name => _name;
  String? get id => _id;
  String? get userId => _userId;
  String? get code => _code;
  String? get alias => _alias;
  String? get createdDate => _createdDate;
  bool? get isDefault => _isDefault;
  bool? get status => _status;
  String? get subjectDN => _subjectDN;
  String? get userPIN => _userPIN;
  bool? get hasUserPIN => _hasUserPIN;
  String? get validFrom => _validFrom;
  String? get validTo => _validTo;
  String? get certificateBase64 => _certificateBase64;
  num? get accountType => _accountType;

  bool get selected => _selected ?? false;

  set selected(bool value) {
    _selected = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    map['userId'] = _userId;
    map['code'] = _code;
    map['alias'] = _alias;
    map['createdDate'] = _createdDate;
    map['isDefault'] = _isDefault;
    map['status'] = _status;
    map['subjectDN'] = _subjectDN;
    map['userPIN'] = _userPIN;
    map['hasUserPIN'] = _hasUserPIN;
    map['validFrom'] = _validFrom;
    map['validTo'] = _validTo;
    map['certificateBase64'] = _certificateBase64;
    map['accountType'] = _accountType;
    return map;
  }
}
