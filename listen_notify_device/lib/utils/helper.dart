import 'package:listen_notify_device/data/storage_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../service_locator.dart';

class Helper {
  final _storage = locator.get<StorageHelper>();

  Future<bool> isIgnore(String package) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final data = await _storage.getFilterPackage();
    return data.contains(package) || package == packageInfo.packageName;
  }
}
