/// code : 200
/// message : "string"
/// traceId : "string"

class AddFirebaseReponse {
  AddFirebaseReponse({
    num? code,
    String? message,
    String? traceId,
  }) {
    _code = code;
    _message = message;
    _traceId = traceId;
  }

  AddFirebaseReponse.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
    _traceId = json['traceId'];
  }
  num? _code;
  String? _message;
  String? _traceId;
  AddFirebaseReponse copyWith({
    num? code,
    String? message,
    String? traceId,
  }) =>
      AddFirebaseReponse(
        code: code ?? _code,
        message: message ?? _message,
        traceId: traceId ?? _traceId,
      );
  num? get code => _code;
  String? get message => _message;
  String? get traceId => _traceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    map['traceId'] = _traceId;
    return map;
  }
}
