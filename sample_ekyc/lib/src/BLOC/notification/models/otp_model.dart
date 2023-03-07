import 'dart:convert';

class NotificationOtp {
  NotificationOtp({
    // required this.remainingSecond,
    this.sadRequestId,
    this.jwt,
    this.requestId,
    this.otp,
  });

  // final String remainingSecond;
  final String? sadRequestId;
  final String? jwt;
  final String? requestId;
  final String? otp;

  factory NotificationOtp.fromJson(String str) =>
      NotificationOtp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationOtp.fromMap(Map<String, dynamic> json) => NotificationOtp(
        // remainingSecond:
        //     json["remainingSecond"] == null ? null : json["remainingSecond"],
        sadRequestId:
            json["sadRequestId"] == null ? null : json["sadRequestId"],
        jwt: json["jwt"] == null ? null : json["jwt"],
        requestId: json["requestId"] == null ? null : json["requestId"],
        otp: json["otp"] == null ? null : json["otp"],
      );

  Map<String, dynamic> toMap() => {
        // "remainingSecond": remainingSecond,
        "sadRequestId": sadRequestId,
        "jwt": jwt,
        "requestId": requestId,
        "otp": otp,
      };

  static final NotificationOtp empty = NotificationOtp(
    jwt: '',
    // remainingSecond: '',
    requestId: '',
    otp: '',
    sadRequestId: '',
  );
}
