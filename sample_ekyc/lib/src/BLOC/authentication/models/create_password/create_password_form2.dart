import 'package:collection/collection.dart';

class CreatePasswordForm2 {
  String? oldPassword;
  String? newPassword;
  String? otp;

  CreatePasswordForm2({
    this.oldPassword,
    this.newPassword,
    this.otp,
  });

  @override
  String toString() {
    return 'CreatePasswordForm2(oldPassword: $oldPassword, newPassword: $newPassword, otp: $otp)';
  }

  factory CreatePasswordForm2.fromJson(Map<String, dynamic> json) {
    return CreatePasswordForm2(
      oldPassword: json['oldPassword'] as String?,
      newPassword: json['newPassword'] as String?,
      otp: json['otp'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'otp': otp,
      };

  CreatePasswordForm2 copyWith({
    String? userId,
    String? oldPassword,
    String? newPassword,
    String? otp,
  }) {
    return CreatePasswordForm2(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      otp: otp ?? this.otp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CreatePasswordForm2) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      oldPassword.hashCode ^ newPassword.hashCode ^ otp.hashCode;
}
