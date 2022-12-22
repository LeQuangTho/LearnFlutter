import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:listen_notify_device/data/service_notification.dart';
import 'package:listen_notify_device/dialogs/request_permission.dart';
import 'package:listen_notify_device/utils/helper.dart';
import 'package:listen_notify_device/widgets/notification_tile.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import '../data/hive_helper.dart';
import '../dialogs/manager_package_ignore.dart';
import '../dialogs/storage_limit.dart';

class SaveWithNotification extends StatefulWidget {
  const SaveWithNotification({Key? key}) : super(key: key);

  @override
  State<SaveWithNotification> createState() => _SaveWithNotificationState();
}

class _SaveWithNotificationState extends State<SaveWithNotification> {
  List<ServiceNotification> events = [];
  final localData = HiveHelper();
  final _helper = Helper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!await NotificationListenerService.isPermissionGranted()) {
        final res = await requestPermission(context);
        if (!res) {
          exit(0);
        } else {
          AppSettings.openAppSettings();
        }
      }
      NotificationListenerService.notificationsStream.listen((event) async {
        if (!(await _helper.isIgnore(event.packageName ?? ''))) {
          events.add(ServiceNotification.fromServiceNotificationEvent(event));
          setState(() {});
        }
      });
      events = await localData.getAllNotification();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications All App'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.settings,
            ),
            onSelected: (value) {
              switch (value) {
                case 1:
                  managerPackageIgnore(context);
                  break;
                case 2:
                  storageLimit(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Manager package listener'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Storage limit'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: events.isNotEmpty
          ? FloatingActionButton(
              child: const Icon(
                Icons.cleaning_services_rounded,
              ),
              onPressed: () async {
                await localData.cleanNotification();
                setState(() {
                  events = [];
                });
              },
            )
          : null,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: SafeArea(
        child: events.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  events = await localData.getAllNotification();
                  setState(() {});
                },
                child: ListView.separated(
                  reverse: true,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: events.length,
                  itemBuilder: (_, index) => NotificationTile(events[index]),
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.hourglass_empty),
                    Text('Empty'),
                  ],
                ),
              ),
      ),
    );
  }
}
