class Response {
  bool success;
  int code;
  String message;
  dynamic data;

  Response({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
}

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: json['data']);
}
