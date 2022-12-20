import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:notification_listener_service/notification_event.dart';

part 'service_notification.g.dart';

@HiveType(typeId: 0)
class ServiceNotification {
  @HiveField(0)
  int? id;
  @HiveField(1)
  bool? canReply;
  @HiveField(2)
  bool? hasExtrasPicture;
  @HiveField(3)
  bool? hasRemoved;
  @HiveField(4)
  Uint8List? extrasPicture;
  @HiveField(5)
  String? packageName;
  @HiveField(6)
  String? title;
  @HiveField(7)
  Uint8List? notificationIcon;
  @HiveField(8)
  String? content;

  ServiceNotification({
    this.id,
    this.canReply,
    this.hasExtrasPicture,
    this.hasRemoved,
    this.extrasPicture,
    this.packageName,
    this.title,
    this.notificationIcon,
    this.content,
  });

  factory ServiceNotification.fromServiceNotificationEvent(
          ServiceNotificationEvent value) =>
      ServiceNotification(
        canReply: value.canReply,
        notificationIcon: value.notificationIcon,
        content: value.content,
        extrasPicture: value.extrasPicture,
        hasExtrasPicture: value.hasExtrasPicture,
        hasRemoved: value.hasRemoved,
        id: value.id,
        packageName: value.packageName,
        title: value.title,
      );
}
