import 'dart:convert';

class CreatePasswordForm {
  final String password;
  final String rePassword;
  final String registerToken;
  CreatePasswordForm({
    required this.password,
    required this.rePassword,
    required this.registerToken,
  });

  CreatePasswordForm copyWith({
    String? password,
    String? re_password,
    String? register_token,
  }) {
    return CreatePasswordForm(
      password: password ?? this.password,
      rePassword: re_password ?? this.rePassword,
      registerToken: register_token ?? this.registerToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      're_password': rePassword,
      'register_token': registerToken,
    };
  }

  factory CreatePasswordForm.fromMap(Map<String, dynamic> map) {
    return CreatePasswordForm(
      password: map['password'] ?? '',
      rePassword: map['re_password'] ?? '',
      registerToken: map['register_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatePasswordForm.fromJson(String source) =>
      CreatePasswordForm.fromMap(json.decode(source));

  @override
  String toString() =>
      'CreatePasswordForm(password: $password, re_password: $rePassword, register_token: $registerToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatePasswordForm &&
        other.password == password &&
        other.rePassword == rePassword &&
        other.registerToken == registerToken;
  }

  @override
  int get hashCode =>
      password.hashCode ^ rePassword.hashCode ^ registerToken.hashCode;
}
