import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notify/utils.dart';

class Notify {
  static final _notification = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    // playSound: true,
    sound: RawResourceAndroidNotificationSound("sound_notify"),
    enableVibration: false,
  );

  static init() async {
    await _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(channel);
  }

  static _notificationDetail() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        color: Colors.blue,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(
            await Utils.downloadFile(
              "https://jackfruit.com.vn/content/images/2022/01/6078b650748b8558d46ffb7f_Flutter-app-development.png",
              "bigPicturePath",
            ),
          ),
          largeIcon: FilePathAndroidBitmap(
            await Utils.downloadFile(
              "https://jackfruit.com.vn/content/images/2022/01/6078b650748b8558d46ffb7f_Flutter-app-development.png",
              "largerPicturePath",
            ),
          ),
        ),
      ),
      iOS: const IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(
        Random().nextInt(10000),
        "Testing",
        "This is an Flutter Push Notification",
        await _notificationDetail(),
        payload: payload,
      );
}
