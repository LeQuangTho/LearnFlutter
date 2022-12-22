import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listen_notify_device/data/service_notification.dart';
import 'package:listen_notify_device/pages/save_with_notifications.dart';
import 'package:listen_notify_device/service_locator.dart';
import 'package:listen_notify_device/utils/helper.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:sizer/sizer.dart';

import 'data/hive_helper.dart';

const notificationChannelId = 'my_foreground';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setupLocator();
  await Hive.initFlutter();
  await HiveHelper.adapter();
  await HiveHelper.initialBox();

  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.purple,
          ),
          debugShowCheckedModeBanner: false,
          home: const SaveWithNotification(),
        );
      },
    );
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Save Notification Apps',
      initialNotificationContent: 'Listening...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}

@pragma('vm:entry-point')
onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  setupLocator();

  final helper = Helper();
  await Hive.initFlutter();
  await HiveHelper.adapter();

  await HiveHelper.initialBox();

  final localData = locator.get<HiveHelper>();

  NotificationListenerService.notificationsStream.listen((event) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    //   // bring to foreground
    if (service is AndroidServiceInstance &&
        !(await helper.isIgnore(event.packageName ?? ''))) {
      await localData.addNotification(
          ServiceNotification.fromServiceNotificationEvent(event));

      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'Save Notification Apps',
          'Listening...${(await localData.getAllNotification()).length}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              color: Colors.green,
              icon: '@mipmap/launcher_icon',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });
}
