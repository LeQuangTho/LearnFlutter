import 'dart:convert';

class LoginForm {
  LoginForm({
    required this.username,
    required this.password,
    required this.remember,
    required this.deviceInfo,
  });

  final String username;
  final String password;
  final bool remember;
  final Map<String, dynamic> deviceInfo;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "username": username,
        "password": password,
        "remember": remember,
        "device_info": deviceInfo,
      };
}
