import 'package:hive_flutter/hive_flutter.dart';
import 'package:listen_notify_device/data/service_notification.dart';

const String BOX = 'BOX';

class HiveHelper {
  static Future<void> initialBox() async {
    await Hive.openBox(BOX);
  }

  static Future<void> adapter() async {
    Hive.registerAdapter<ServiceNotification>(ServiceNotificationAdapter());
  }

  Future<void> addNotification(ServiceNotification notify) async {
    final box = Hive.box(BOX);

    await box.add(notify);
  }

  Future<void> cleanNotification() async {
    final box = Hive.box(BOX);

    await box.clear();
  }

  Future<List<ServiceNotification>> getAllNotification() async {
    final box = Hive.box(BOX);

    final data = box.values.toList();

    if (data is List<ServiceNotification>) {
      print('object');
      return data;
    } else {
      print('no');
      return [];
    }
  }
}
