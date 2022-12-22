import 'package:flutter/material.dart';

import '../data/service_notification.dart';
import '../data/storage_helper.dart';
import '../service_locator.dart';

showDetailNotification(BuildContext context,
    {required ServiceNotification item}) async {
  final storageHelper = locator.get<StorageHelper>();
  final packages = await storageHelper.getFilterPackage();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Text(
        item.content ?? 'Không rõ nội dung!',
      ),
      title: Text(item.title ?? 'Thông báo'),
      icon: Center(
        child: Container(
          height: 70,
          width: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0XFF6A7381).withOpacity(0.16),
                offset: const Offset(0, 2),
                blurRadius: 8,
              )
            ],
          ),
          child: item.extrasPicture != null
              ? Image.memory(
                  item.notificationIcon ?? item.extrasPicture!,
                )
              : const FlutterLogo(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: !packages.contains(item.packageName ?? '')
              ? () async {
                  storageHelper.addFilterPackage(item.packageName ?? '');
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Ignore'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
