import 'data.dart';

class DetailOcrResponse {
  Data? data;
  int? code;
  String? message;
  String? traceId;

  DetailOcrResponse({this.data, this.code, this.message, this.traceId});

  @override
  String toString() {
    return 'DetailOcrResponse(data: $data, code: $code, message: $message, traceId: $traceId)';
  }

  factory DetailOcrResponse.fromJson(Map<String, dynamic> json) {
    return DetailOcrResponse(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      code: json['code'] as int?,
      message: json['message'] as String?,
      traceId: json['traceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'code': code,
        'message': message,
        'traceId': traceId,
      };

  DetailOcrResponse copyWith({
    Data? data,
    int? code,
    String? message,
    String? traceId,
  }) {
    return DetailOcrResponse(
      data: data ?? this.data,
      code: code ?? this.code,
      message: message ?? this.message,
      traceId: traceId ?? this.traceId,
    );
  }

  static DetailOcrResponse empty = DetailOcrResponse();
}
