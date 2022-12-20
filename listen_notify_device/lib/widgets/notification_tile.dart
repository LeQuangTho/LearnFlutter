import 'package:flutter/material.dart';
import 'package:listen_notify_device/data/service_notification.dart';

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
              // item.notificationIcon!,
              width: 35.0,
              height: 35.0,
            )
          : const FlutterLogo(),
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
                  "Replied with: This is an auto reply",
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                )
              : const SizedBox.shrink(),
          (item.hasExtrasPicture ?? false)
              ? Image.memory(
                  item.extrasPicture!,
                  // item.extrasPicture!,
                )
              : const SizedBox.shrink(),
        ],
      ),
      isThreeLine: true,
    );
  }
}
