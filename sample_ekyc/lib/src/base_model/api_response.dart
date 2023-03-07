class ApiResponse<T> {
  int? code;
  String? message;
  String? traceId;
  T? data;

  ApiResponse({this.code, this.message, this.traceId, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        code: json['code'] as int?,
        message: json['message'] as String?,
        traceId: json['traceId'] as String?,
        data: json['data'] as T?,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'traceId': traceId,
        'data': data,
      };
}
