/// code : 200
/// message : "string"
/// traceId : "string"
/// data : [{"title":"string","type":0,"countNum":0}]

class ContractStatusResponse {
  ContractStatusResponse({
    num? code,
    String? message,
    String? traceId,
    List<StatusContract>? data,
  }) {
    _code = code;
    _message = message;
    _traceId = traceId;
    _data = data;
  }

  ContractStatusResponse.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(StatusContract.fromJson(v));
      });
    }
  }
  num? _code;
  String? _message;
  String? _traceId;
  List<StatusContract>? _data;
  ContractStatusResponse copyWith({
    num? code,
    String? message,
    String? traceId,
    List<StatusContract>? data,
  }) =>
      ContractStatusResponse(
        code: code ?? _code,
        message: message ?? _message,
        traceId: traceId ?? _traceId,
        data: data ?? _data,
      );
  num? get code => _code;
  String? get message => _message;
  String? get traceId => _traceId;
  List<StatusContract>? get data => _data;

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

/// title : "string"
/// type : 0
/// countNum : 0

class StatusContract {
  StatusContract({
    String? title,
    num? type,
    num? countNum,
  }) {
    _title = title;
    _type = type;
    _countNum = countNum;
  }

  StatusContract.fromJson(dynamic json) {
    _title = json['title'];
    _type = json['type'];
    _countNum = json['countNum'];
  }
  String? _title;
  num? _type;
  num? _countNum;
  StatusContract copyWith({
    String? title,
    num? type,
    num? countNum,
  }) =>
      StatusContract(
        title: title ?? _title,
        type: type ?? _type,
        countNum: countNum ?? _countNum,
      );
  String? get title => _title;
  num? get type => _type;
  num? get countNum => _countNum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['type'] = _type;
    map['countNum'] = _countNum;
    return map;
  }

  static final empty = StatusContract();
}
