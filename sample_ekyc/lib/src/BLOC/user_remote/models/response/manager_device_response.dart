/// data : [{"id":"8ed984f8-fdda-4c87-82af-cce9f8259608","deviceId":"7984BBC3-FF29-45DA-911B-954EFCA08AF1","deviceName":"7984BBC3-FF29-45DA-911B-954EFCA08AF1","isIdentifierDevice":false,"createdDate":"2022-11-15T14:36:28.526438"},{"id":"892bb813-0376-4763-89ef-b989a92d73c6","deviceId":"7FFE2B29-9004-41C6-80A0-6D50071C5C98","deviceName":"7FFE2B29-9004-41C6-80A0-6D50071C5C98","isIdentifierDevice":true,"createdDate":"2022-11-11T14:58:00.079879","lastLoginTime":"2022-11-15T16:20:04.800343"}]
/// code : 200
/// message : "Tải dữ liệu thành công"
/// traceId : "6d8facd5-d119-47a0-a885-a46bd8bdabf2"

class ManagerDeviceResponse {
  ManagerDeviceResponse({
      List<DeviceDataEntry>? data,
      num? code, 
      String? message, 
      String? traceId,}){
    _data = data;
    _code = code;
    _message = message;
    _traceId = traceId;
}

  ManagerDeviceResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DeviceDataEntry.fromJson(v));
      });
    }
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
  }
  List<DeviceDataEntry>? _data;
  num? _code;
  String? _message;
  String? _traceId;
ManagerDeviceResponse copyWith({  List<DeviceDataEntry>? data,
  num? code,
  String? message,
  String? traceId,
}) => ManagerDeviceResponse(  data: data ?? _data,
  code: code ?? _code,
  message: message ?? _message,
  traceId: traceId ?? _traceId,
);
  List<DeviceDataEntry>? get data => _data;
  num? get code => _code;
  String? get message => _message;
  String? get traceId => _traceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['code'] = _code;
    map['message'] = _message;
    map['traceId'] = _traceId;
    return map;
  }

}

/// id : "8ed984f8-fdda-4c87-82af-cce9f8259608"
/// deviceId : "7984BBC3-FF29-45DA-911B-954EFCA08AF1"
/// deviceName : "7984BBC3-FF29-45DA-911B-954EFCA08AF1"
/// isIdentifierDevice : false
/// createdDate : "2022-11-15T14:36:28.526438"

class DeviceDataEntry {
  DeviceDataEntry({
      String? id, 
      String? deviceId, 
      String? deviceName, 
      bool? isIdentifierDevice, 
      bool? status,
      String? createdDate,
      String? lastLoginTime,
  }){
    _id = id;
    _deviceId = deviceId;
    _deviceName = deviceName;
    _isIdentifierDevice = isIdentifierDevice;
    _status = status;
    _createdDate = createdDate;
    _lastLoginTime = lastLoginTime;
}

  DeviceDataEntry.fromJson(dynamic json) {
    _id = json['id'];
    _deviceId = json['deviceId'];
    _deviceName = json['deviceName'];
    _isIdentifierDevice = json['isIdentifierDevice'];
    _status = json['status'];
    _createdDate = json['createdDate'];
    _lastLoginTime = json['lastLoginTime'];
  }
  String? _id;
  String? _deviceId;
  String? _deviceName;
  bool? _isIdentifierDevice;
  bool? _status;
  String? _createdDate;
  String? _lastLoginTime;



  DeviceDataEntry copyWith({  String? id,
  String? deviceId,
  String? deviceName,
  bool? isIdentifierDevice,
  bool? status,
  String? createdDate,
  String? lastLoginTime,
}) => DeviceDataEntry(  id: id ?? _id,
  deviceId: deviceId ?? _deviceId,
  deviceName: deviceName ?? _deviceName,
  isIdentifierDevice: isIdentifierDevice ?? _isIdentifierDevice,
    status: status ?? _status,
  createdDate: createdDate ?? _createdDate,
  lastLoginTime: lastLoginTime ?? _lastLoginTime,
);
  String? get id => _id;
  String? get deviceId => _deviceId;
  String? get deviceName => _deviceName;
  bool? get isIdentifierDevice => _isIdentifierDevice;
  bool? get status => _status;
  String? get createdDate => _createdDate;
  String? get lastLoginTime => _lastLoginTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['deviceId'] = _deviceId;
    map['deviceName'] = _deviceName;
    map['isIdentifierDevice'] = _isIdentifierDevice;
    map['status'] = _status;
    map['createdDate'] = _createdDate;
    map['lastLoginTime'] = _lastLoginTime;
    return map;
  }


}