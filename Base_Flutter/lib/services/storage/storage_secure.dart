import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreSecure {
  final _tokenKey = "token";

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock,
    ),
  );

  Future setToken(String? token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }
}