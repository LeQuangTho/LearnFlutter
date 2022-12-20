import 'package:flutter/material.dart';
import 'package:listen_notify_device/data/service_notification.dart';
import 'package:listen_notify_device/widgets/notification_tile.dart';

import 'data/hive_helper.dart';

class SaveWithNotification extends StatefulWidget {
  const SaveWithNotification({Key? key}) : super(key: key);

  @override
  State<SaveWithNotification> createState() => _SaveWithNotificationState();
}

class _SaveWithNotificationState extends State<SaveWithNotification> {
  List<ServiceNotification> events = [];
  final localData = HiveHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      events = await localData.getAllNotification();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications All App'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.cleaning_services_rounded,
        ),
        onPressed: () async {
          await localData.cleanNotification();
          setState(() {
            events = [];
          });
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            events = await localData.getAllNotification();
            setState(() {});
          },
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: events.length,
            itemBuilder: (_, index) => NotificationTile(events[index]),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
