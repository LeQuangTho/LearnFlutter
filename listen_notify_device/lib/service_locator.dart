import 'package:get_it/get_it.dart';
import 'package:listen_notify_device/data/hive_helper.dart';
import 'package:listen_notify_device/data/storage_helper.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<HiveHelper>(HiveHelper());
  locator.registerSingleton<StorageHelper>(StorageHelper());
}
