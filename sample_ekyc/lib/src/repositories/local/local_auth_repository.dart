// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hdsaison_signing/src/repositories/local/shared_pref.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/hard_constants.dart';
import '../../constants/local_storage_keys.dart';

class UserPrivateRepo {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final secureStorage = FlutterSecureStorage();

  Future<bool> authenticateUser() async {
    bool authenticated = false;
    if (await _isBiometricAvailable()) {
      await _getBiometricTypes();
      authenticated = await _authenticateUser();
    }
    return authenticated;
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    isAvailable
        ? print("Biometric is available")
        : print("Biometric is not available");
    return isAvailable;
  }

  Future<void> _getBiometricTypes() async {
    List<BiometricType> biometrics = [];
    try {
      biometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    print(biometrics.toString());
  }

  Future<List<BiometricType>> getBiometricTypes() async {
    List<BiometricType> biometrics = [];
    try {
      biometrics = await _localAuthentication.getAvailableBiometrics();
      return biometrics;
    } on PlatformException catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: "Please authenticate",
          options: AuthenticationOptions(
            useErrorDialogs: false,
            biometricOnly: false,
          ));
      isAuthenticated
          ? print('User is authenticated!')
          : print('User is not authenticated.');
      return isAuthenticated;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> setPIN(
    String userId,
    String PIN,
  ) async {
    await secureStorage.write(key: userId, value: PIN);
    final String? pin = await getPIN(userId: userId);
    return pin == PIN;
  }

  Future<bool> clearPIN(String userId, {String PIN = ''}) async {
    await secureStorage.write(key: userId, value: PIN);
    final String? pin = await getPIN(userId: userId);
    return pin == PIN;
  }

  Future<String?> getPIN({required userId}) async {
    String? value = await secureStorage.read(key: userId);
    if (value != null || (value ?? '').isNotEmpty) {
      return value;
    } else {
      return null;
    }
  }

  Future<String?> getAccount(String username) async {
    String? value = await secureStorage.read(key: CURRENT_USER + username);
    if (value != null || (value ?? '').isNotEmpty) {
      return value;
    } else {
      return null;
    }
  }

  Future<bool> saveBiometricAccount(
    BiometricAccount account,
  ) async {
    String value = account.toJson();
    await secureStorage.write(
        key: CURRENT_USER + account.bioUsername!, value: value);
    final String? savedValue = await getAccount(account.bioUsername!);
    return savedValue == value;
  }

  Future<BiometricAccount> getBiometricAccount(String username) async {
    String? value = await secureStorage.read(key: CURRENT_USER + username);
    if (value != null || (value ?? '').isNotEmpty) {
      return BiometricAccount.fromJson(value!);
    } else {
      return BiometricAccount.empty;
    }
  }

  Future<String?> getUsername(
      {String key = LocalStorageKey.BOX_USERNAME}) async {
    String? value = await secureStorage.read(key: key);
    if (value != null || (value ?? '').isNotEmpty) {
      return value;
    } else {
      return null;
    }
  }

  Future<bool> saveUsername(String username,
      {String key = LocalStorageKey.BOX_USERNAME}) async {
    await secureStorage.write(key: key, value: username);
    final String? savedUsername = await getUsername();
    return savedUsername == username;
  }

  Future<void> saveAppOpened(bool opened) async {
    await PreferenceManager.setBool(PreferenceManager.isOpenedApp, opened);
  }

  Future<bool> saveAppLoginFirst(bool firstLogin) async {
    await secureStorage.write(key: 'firstLogin', value: firstLogin.toString());
    String? value = await getCheckLoginFirst();
    print('>>>>>>>> is login first $value');
    return firstLogin.toString() == value;
  }

  Future<String?> getCheckLoginFirst() async {
    String? value = await secureStorage.read(key: 'firstLogin');
    if (value != null || (value ?? '').isNotEmpty) {
      print('>>>>>>>> get is login first $value');
      return value;
    } else {
      return null;
    }
  }

  Future<bool> getCheckAppOpened() async {
    final result = await PreferenceManager.getBool(PreferenceManager.isOpenedApp, false);
    print('>>>>> isOpenedApp $result');
    return result;
  }

  Future<bool> clearUsername(
      {String username = '', String key = LocalStorageKey.BOX_USERNAME}) async {
    await secureStorage.write(key: key, value: username);
    final String? savedUsername = await getUsername();
    return savedUsername == username;
  }

  Future<String?> getPassword({required String username}) async {
    String? value = await secureStorage.read(key: username);
    if (value != null || (value ?? '').isNotEmpty) {
      return value;
    } else {
      return null;
    }
  }

  Future<bool> savePassword(String password, {required String username}) async {
    await secureStorage.write(key: username, value: password);
    final String? savedPassword = await getPassword(username: username);
    return savedPassword == password;
  }

  Future<bool> clearPassword(
      {String password = '', required String username}) async {
    await secureStorage.write(key: username, value: password);
    final String? savedPassword = await getPassword(username: username);
    return savedPassword == password;
  }

  Future<bool> activeBiometric(
      {required String username, required String password}) async {
    if (await _authenticateUser()) {
      final BiometricAccount account =
          BiometricAccount(bioUsername: username, bioPassword: password);
      await saveBiometricAccount(account);
      return account == await getBiometricAccount(username);
    } else {
      return false;
    }
  }
}

class BiometricAccount extends Equatable {
  BiometricAccount({
    required this.bioUsername,
    required this.bioPassword,
  });

  String? bioUsername;
  String? bioPassword;

  factory BiometricAccount.fromJson(String str) =>
      BiometricAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BiometricAccount.fromMap(Map<String, dynamic> json) =>
      BiometricAccount(
        bioUsername: json["bio_username"] == null ? null : json["bio_username"],
        bioPassword: json["bio_password"] == null ? null : json["bio_password"],
      );

  Map<String, dynamic> toMap() => {
        "bio_username": bioUsername,
        "bio_password": bioPassword,
      };

  static final empty = BiometricAccount(bioUsername: '', bioPassword: '');

  @override
  List<Object?> get props => [bioUsername, bioPassword];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiometricAccount &&
          runtimeType == other.runtimeType &&
          bioUsername == other.bioUsername &&
          bioPassword == other.bioPassword;
}
