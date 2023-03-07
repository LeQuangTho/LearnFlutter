import 'data.dart';

class EkycEformCTSResponse {
  EkycEformCTSData? data;
  int? code;
  String? message;
  String? traceId;

  EkycEformCTSResponse({this.data, this.code, this.message, this.traceId});

  @override
  String toString() {
    return 'EkycEformResponse(data: $data, code: $code, message: $message, traceId: $traceId)';
  }

  factory EkycEformCTSResponse.fromJson(Map<String, dynamic> json) {
    return EkycEformCTSResponse(
      data: json['data'] == null
          ? null
          : EkycEformCTSData.fromJson(json['data'] as Map<String, dynamic>),
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

  EkycEformCTSResponse copyWith({
    EkycEformCTSData? data,
    int? code,
    String? message,
    String? traceId,
  }) {
    return EkycEformCTSResponse(
      data: data ?? this.data,
      code: code ?? this.code,
      message: message ?? this.message,
      traceId: traceId ?? this.traceId,
    );
  }
}
