import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

requestPermission(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: const Text(
        'Cần phải có quyền đọc thông báo và tự động chạy lại!',
      ),
      title: const Text('Request Permission'),
      actions: [
        TextButton(
          onPressed: () async {
            final res = await NotificationListenerService.requestPermission();
            log("Is enabled: $res");

            Navigator.of(context).pop(res);
          },
          child: const Text('Tiếp'),
        ),
      ],
    ),
  );
}
