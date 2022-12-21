import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const String STORAGE_PACKAGE = 'STORAGE_PACKAGE';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<List<String>> getFilterPackage() async {
    final all = await _storage.read(
          key: STORAGE_PACKAGE,
        ) ??
        '[]';

    final packages = jsonDecode(all);
    return (packages as List).cast<String>();
  }

  addAllFilterPackage(List<String> packages) async {
    final dataOld = await getFilterPackage();
    dataOld.addAll(packages);
    await _storage.write(
      key: STORAGE_PACKAGE,
      value: jsonEncode(dataOld),
    );
  }

  addFilterPackage(String package) async {
    if (package.isEmpty) return;

    final dataOld = await getFilterPackage();

    if (dataOld.contains(package)) return;

    dataOld.add(package);
    await _storage.write(
      key: STORAGE_PACKAGE,
      value: jsonEncode(dataOld),
    );
  }

  Future<void> deletePackageIgnore(List<String> packages) async {
    if (packages.isEmpty) return;

    final dataOld = await getFilterPackage();

    dataOld.removeWhere(
      (element) => packages.contains(element),
    );

    await _storage.write(
      key: STORAGE_PACKAGE,
      value: jsonEncode(dataOld),
    );
  }
}
