/// code : 200
/// message : "string"
/// traceId : "string"
/// data : {"draft":0,"waitMeSign":0,"processing":0,"completed":0,"rejectSign":0}

class EContractCountResponse {
  EContractCountResponse({
    num? code,
    String? message,
    String? traceId,
    EContractCountDataEntry? data,
  }) {
    _code = code;
    _message = message;
    _traceId = traceId;
    _data = data;
  }

  EContractCountResponse.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
    _data = json['data'] != null
        ? EContractCountDataEntry.fromJson(json['data'])
        : null;
  }
  num? _code;
  String? _message;
  String? _traceId;
  EContractCountDataEntry? _data;
  EContractCountResponse copyWith({
    num? code,
    String? message,
    String? traceId,
    EContractCountDataEntry? data,
  }) =>
      EContractCountResponse(
        code: code ?? _code,
        message: message ?? _message,
        traceId: traceId ?? _traceId,
        data: data ?? _data,
      );
  num? get code => _code;
  String? get message => _message;
  String? get traceId => _traceId;
  EContractCountDataEntry? get data => _data;

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

/// draft : 0
/// waitMeSign : 0
/// processing : 0
/// completed : 0
/// rejectSign : 0

class EContractCountDataEntry {
  EContractCountDataEntry({
    num? waitMeSign,
    num? processing,
    num? completed,
    num? rejectSign,
  }) {
    _waitMeSign = waitMeSign;
    _processing = processing;
    _completed = completed;
    _rejectSign = rejectSign;
  }

  EContractCountDataEntry.fromJson(dynamic json) {
    _waitMeSign = json['waitMeSign'];
    _processing = json['processing'];
    _completed = json['completed'];
    _rejectSign = json['rejectSign'];
  }
  num? _waitMeSign;
  num? _processing;
  num? _completed;
  num? _rejectSign;
  EContractCountDataEntry copyWith({
    num? draft,
    num? waitMeSign,
    num? processing,
    num? completed,
    num? rejectSign,
  }) =>
      EContractCountDataEntry(
        waitMeSign: waitMeSign ?? _waitMeSign,
        processing: processing ?? _processing,
        completed: completed ?? _completed,
        rejectSign: rejectSign ?? _rejectSign,
      );
  num? get waitMeSign => _waitMeSign;
  num? get processing => _processing;
  num? get completed => _completed;
  num? get rejectSign => _rejectSign;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['waitMeSign'] = _waitMeSign;
    map['processing'] = _processing;
    map['completed'] = _completed;
    map['rejectSign'] = _rejectSign;
    return map;
  }

  static final empty = EContractCountDataEntry();
}
