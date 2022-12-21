import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listen_notify_device/data/service_notification.dart';
import 'package:listen_notify_device/dialogs/detail_notification.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile(this.item, {Key? key}) : super(key: key);
  final ServiceNotification item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        // try {
        //   await item.sendReply("This is an auto response");
        // } catch (e) {
        //   log(e.toString());
        // }
        showDetailNotification(context, item: item);
      },
      trailing: (item.hasRemoved ?? false)
          ? const Text(
              "Removed",
              style: TextStyle(color: Colors.red),
            )
          : const SizedBox.shrink(),
      leading: item.notificationIcon != null
          ? Image.memory(
              item.notificationIcon!,
              width: 50.0,
              height: 50.0,
            )
          : const FlutterLogo(
              size: 50,
            ),
      title: Text(item.title ?? "No title"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.content ?? "no content",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          (item.canReply ?? false)
              ? const Text(
                  "You can reply!",
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                )
              : const SizedBox.shrink(),
          (item.hasExtrasPicture ?? false)
              ? Image.memory(
                  item.extrasPicture!,
                )
              : const SizedBox.shrink(),
          Text(
            DateFormat.yMd().add_jm().format(item.dateTime ?? DateTime.now()),
            style: const TextStyle(
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
      // isThreeLine: true,
    );
  }
}
