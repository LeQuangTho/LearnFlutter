/// code : 200
/// message : "string"
/// traceId : "string"
/// data : {"id":"3fa85f64-5717-4562-b3fc-2c963f66afa6","phoneNumber":"string","email":"string","name":"string","birthday":"2022-10-12T08:20:16.500Z","identityNumber":"string","permanentAddress":"string","placeOfOrigin":"string"}

class UserInforResponse {
  UserInforResponse({
    num? code,
    String? message,
    String? traceId,
    UserResponseDataEntry? data,
  }) {
    _code = code;
    _message = message;
    _traceId = traceId;
    _data = data;
  }

  UserInforResponse.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
    _data = json['data'] != null
        ? UserResponseDataEntry.fromJson(json['data'])
        : null;
  }
  num? _code;
  String? _message;
  String? _traceId;
  UserResponseDataEntry? _data;
  UserInforResponse copyWith({
    num? code,
    String? message,
    String? traceId,
    UserResponseDataEntry? data,
  }) =>
      UserInforResponse(
        code: code ?? _code,
        message: message ?? _message,
        traceId: traceId ?? _traceId,
        data: data ?? _data,
      );
  num? get code => _code;
  String? get message => _message;
  String? get traceId => _traceId;
  UserResponseDataEntry? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    map['traceId'] = _traceId;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// id : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// phoneNumber : "string"
/// email : "string"
/// name : "string"
/// birthday : "2022-10-12T08:20:16.500Z"
/// identityNumber : "string"
/// permanentAddress : "string"
/// placeOfOrigin : "string"

class UserResponseDataEntry {
  UserResponseDataEntry({
    String? id,
    String? phoneNumber,
    String? email,
    String? name,
    String? birthday,
    String? identityNumber,
    String? address,
    String? permanentAddress,
    String? placeOfOrigin,
  }) {
    _id = id;
    _phoneNumber = phoneNumber;
    _address = address;
    _email = email;
    _name = name;
    _birthday = birthday;
    _identityNumber = identityNumber;
    _permanentAddress = permanentAddress;
    _placeOfOrigin = placeOfOrigin;
  }

  UserResponseDataEntry.fromJson(dynamic json) {
    _id = json['id'];
    _phoneNumber = json['phoneNumber'];
    _address = json['address'];
    _email = json['email'];
    _name = json['name'];
    _birthday = json['birthday'];
    _identityNumber = json['identityNumber'];
    _permanentAddress = json['permanentAddress'];
    _placeOfOrigin = json['placeOfOrigin'];
  }
  String? _id;
  String? _phoneNumber;
  String? _email;
  String? _name;
  String? _birthday;
  String? _identityNumber;
  String? _address;
  String? _permanentAddress;
  String? _placeOfOrigin;
  UserResponseDataEntry copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? name,
    String? address,
    String? birthday,
    String? identityNumber,
    String? permanentAddress,
    String? placeOfOrigin,
  }) =>
      UserResponseDataEntry(
        id: id ?? _id,
        phoneNumber: phoneNumber ?? _phoneNumber,
        email: email ?? _email,
        name: name ?? _name,
        address: address ?? _address,
        birthday: birthday ?? _birthday,
        identityNumber: identityNumber ?? _identityNumber,
        permanentAddress: permanentAddress ?? _permanentAddress,
        placeOfOrigin: placeOfOrigin ?? _placeOfOrigin,
      );
  String? get id => _id;
  String? get phoneNumber => _phoneNumber;
  String? get email => _email;
  String? get name => _name;
  String? get address => _address;
  String? get birthday => _birthday;
  String? get identityNumber => _identityNumber;
  String? get permanentAddress => _permanentAddress;
  String? get placeOfOrigin => _placeOfOrigin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phoneNumber'] = _phoneNumber;
    map['email'] = _email;
    map['name'] = _name;
    map['currentAddress'] = _address;
    map['birthday'] = _birthday;
    map['identityNumber'] = _identityNumber;
    map['permanentAddress'] = _permanentAddress;
    map['placeOfOrigin'] = _placeOfOrigin;
    return map;
  }

  static final empty = UserResponseDataEntry();
}
