import '../../../user_remote/models/response/user_model.dart';

/// data : {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwibmFtZWlkIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwianRpIjoiYjE4YmM5ODAtYTQzOC00NTVjLWJjOTktNGFmZGRlYzBiMjBkIiwieC11c2VyLWVtYWlsIjoic3RyaW5nIiwieC11c2VyLW5hbWUiOiJ2Yy5hZG1pbiIsIngtZnVsbC1uYW1lIjoic3RyaW5nIiwieC1vcmctaWQiOiI2NWE4OWI5NC0zYjE0LTRlMDgtYTZkNi0yYjNiMjQ2MDA3MjIiLCJ4LXVzZXItaWQiOiIzYTRhMjc2YS0zNzI4LTQzMTItOWIyZC1jYzdkYjY5MWY0MWYiLCJuYmYiOjE2NjU2NDc3NjAsImV4cCI6MTY2NTY1MTM2MCwiaXNzIjoiU0FWSVMgQ09SUCIsImF1ZCI6IlNBVklTIENPUlAifQ.O2TjwYu7WpdX4nzzFa8hj2DBc0lGawkxANBB9Bq3AgA","id_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwibmFtZWlkIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwianRpIjoiYjE4YmM5ODAtYTQzOC00NTVjLWJjOTktNGFmZGRlYzBiMjBkIiwieC11c2VyLWVtYWlsIjoic3RyaW5nIiwieC11c2VyLW5hbWUiOiJ2Yy5hZG1pbiIsIngtZnVsbC1uYW1lIjoic3RyaW5nIiwieC1vcmctaWQiOiI2NWE4OWI5NC0zYjE0LTRlMDgtYTZkNi0yYjNiMjQ2MDA3MjIiLCJ4LXVzZXItaWQiOiIzYTRhMjc2YS0zNzI4LTQzMTItOWIyZC1jYzdkYjY5MWY0MWYiLCJuYmYiOjE2NjU2NDc3NjAsImV4cCI6MTY2NTY1MTM2MCwiaXNzIjoiU0FWSVMgQ09SUCIsImF1ZCI6IlNBVklTIENPUlAifQ.O2TjwYu7WpdX4nzzFa8hj2DBc0lGawkxANBB9Bq3AgA","expires_in":3600,"start_time":"10/13/2022 14:56:00","expires_time":"10/13/2022 15:56:00","token_type":"Bearer","userModel":{"eFormConfig":1,"identityNumber":"string","order":0,"hasUserPIN":false,"isApproveAutoSign":false,"isNotRequirePINToSign":false,"isReceiveSystemNoti":false,"isReceiveSignFailNoti":false,"isEKYC":false,"isRequiredChangePassword":false,"id":"3a4a276a-3728-4312-9b2d-cc7db691f41f","name":"string","email":"string","phoneNumber":"string","userName":"vc.admin","isLock":false,"status":true,"organizationId":"65a89b94-3b14-4e08-a6d6-2b3b24600722","isInternalUser":true}}
/// code : 200
/// message : "Tải dữ liệu thành công"

class LoginResponse {
  LoginResponse({
    LoginResponseData? data,
    num? code,
    String? message,
  }) {
    _data = data;
    _code = code;
    _message = message;
  }

  LoginResponse.fromJson(dynamic json) {
    _data =
        json['data'] != null ? LoginResponseData.fromJson(json['data']) : null;
    _code = json['code'];
    _message = json['message'];
  }
  LoginResponseData? _data;
  num? _code;
  String? _message;
  LoginResponse copyWith({
    LoginResponseData? data,
    num? code,
    String? message,
  }) =>
      LoginResponse(
        data: data ?? _data,
        code: code ?? _code,
        message: message ?? _message,
      );
  LoginResponseData? get data => _data;
  num? get code => _code;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['code'] = _code;
    map['message'] = _message;
    return map;
  }
}

/// access_token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwibmFtZWlkIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwianRpIjoiYjE4YmM5ODAtYTQzOC00NTVjLWJjOTktNGFmZGRlYzBiMjBkIiwieC11c2VyLWVtYWlsIjoic3RyaW5nIiwieC11c2VyLW5hbWUiOiJ2Yy5hZG1pbiIsIngtZnVsbC1uYW1lIjoic3RyaW5nIiwieC1vcmctaWQiOiI2NWE4OWI5NC0zYjE0LTRlMDgtYTZkNi0yYjNiMjQ2MDA3MjIiLCJ4LXVzZXItaWQiOiIzYTRhMjc2YS0zNzI4LTQzMTItOWIyZC1jYzdkYjY5MWY0MWYiLCJuYmYiOjE2NjU2NDc3NjAsImV4cCI6MTY2NTY1MTM2MCwiaXNzIjoiU0FWSVMgQ09SUCIsImF1ZCI6IlNBVklTIENPUlAifQ.O2TjwYu7WpdX4nzzFa8hj2DBc0lGawkxANBB9Bq3AgA"
/// id_token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwibmFtZWlkIjoiM2E0YTI3NmEtMzcyOC00MzEyLTliMmQtY2M3ZGI2OTFmNDFmIiwianRpIjoiYjE4YmM5ODAtYTQzOC00NTVjLWJjOTktNGFmZGRlYzBiMjBkIiwieC11c2VyLWVtYWlsIjoic3RyaW5nIiwieC11c2VyLW5hbWUiOiJ2Yy5hZG1pbiIsIngtZnVsbC1uYW1lIjoic3RyaW5nIiwieC1vcmctaWQiOiI2NWE4OWI5NC0zYjE0LTRlMDgtYTZkNi0yYjNiMjQ2MDA3MjIiLCJ4LXVzZXItaWQiOiIzYTRhMjc2YS0zNzI4LTQzMTItOWIyZC1jYzdkYjY5MWY0MWYiLCJuYmYiOjE2NjU2NDc3NjAsImV4cCI6MTY2NTY1MTM2MCwiaXNzIjoiU0FWSVMgQ09SUCIsImF1ZCI6IlNBVklTIENPUlAifQ.O2TjwYu7WpdX4nzzFa8hj2DBc0lGawkxANBB9Bq3AgA"
/// expires_in : 3600
/// start_time : "10/13/2022 14:56:00"
/// expires_time : "10/13/2022 15:56:00"
/// token_type : "Bearer"
/// userModel : {"eFormConfig":1,"identityNumber":"string","order":0,"hasUserPIN":false,"isApproveAutoSign":false,"isNotRequirePINToSign":false,"isReceiveSystemNoti":false,"isReceiveSignFailNoti":false,"isEKYC":false,"isRequiredChangePassword":false,"id":"3a4a276a-3728-4312-9b2d-cc7db691f41f","name":"string","email":"string","phoneNumber":"string","userName":"vc.admin","isLock":false,"status":true,"organizationId":"65a89b94-3b14-4e08-a6d6-2b3b24600722","isInternalUser":true}

class LoginResponseData {
  LoginResponseData({
    String? accessToken,
    String? idToken,
    num? expiresIn,
    String? startTime,
    String? expiresTime,
    String? tokenType,
    bool? isNewDevice,
    UserModel? userModel,
  }) {
    _accessToken = accessToken;
    _idToken = idToken;
    _expiresIn = expiresIn;
    _startTime = startTime;
    _expiresTime = expiresTime;
    _tokenType = tokenType;
    _userModel = userModel;
    _isNewDevice = isNewDevice;
  }

  LoginResponseData.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _idToken = json['id_token'];
    _expiresIn = json['expires_in'];
    _startTime = json['start_time'];
    _expiresTime = json['expires_time'];
    _tokenType = json['token_type'];
    _isNewDevice = json['is_new_device'];
    _userModel = json['userModel'] != null
        ? UserModel.fromJson(json['userModel'])
        : null;
  }
  String? _accessToken;
  String? _idToken;
  num? _expiresIn;
  String? _startTime;
  String? _expiresTime;
  String? _tokenType;
  bool? _isNewDevice;
  UserModel? _userModel;
  LoginResponseData copyWith({
    String? accessToken,
    String? idToken,
    num? expiresIn,
    String? startTime,
    String? expiresTime,
    String? tokenType,
    UserModel? userModel,
  }) =>
      LoginResponseData(
        accessToken: accessToken ?? _accessToken,
        idToken: idToken ?? _idToken,
        expiresIn: expiresIn ?? _expiresIn,
        startTime: startTime ?? _startTime,
        expiresTime: expiresTime ?? _expiresTime,
        tokenType: tokenType ?? _tokenType,
        isNewDevice: isNewDevice ?? _isNewDevice,
        userModel: userModel ?? _userModel,
      );
  String? get accessToken => _accessToken;
  String? get idToken => _idToken;
  num? get expiresIn => _expiresIn;
  String? get startTime => _startTime;
  String? get expiresTime => _expiresTime;
  String? get tokenType => _tokenType;
  bool? get isNewDevice => _isNewDevice;
  UserModel? get userModel => _userModel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['id_token'] = _idToken;
    map['expires_in'] = _expiresIn;
    map['start_time'] = _startTime;
    map['expires_time'] = _expiresTime;
    map['token_type'] = _tokenType;
    map['is_new_device'] = _isNewDevice;
    if (_userModel != null) {
      map['userModel'] = _userModel?.toJson();
    }
    return map;
  }

  static final empty = LoginResponseData();
}
