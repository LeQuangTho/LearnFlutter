import 'data.dart';

class EkycUploadFileResponse {
  int? code;
  String? message;
  String? traceId;
  Data? data;

  EkycUploadFileResponse({
    this.code,
    this.message,
    this.traceId,
    this.data,
  });

  @override
  String toString() {
    return 'EkycUploadFileResponse(code: $code, message: $message, traceId: $traceId, data: $data)';
  }

  factory EkycUploadFileResponse.fromJson(Map<String, dynamic> json) {
    return EkycUploadFileResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      traceId: json['traceId'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'traceId': traceId,
        'data': data?.toJson(),
      };
}
