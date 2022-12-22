import 'package:flutter/material.dart';
import 'package:listen_notify_device/data/storage_helper.dart';
import 'package:listen_notify_device/service_locator.dart';

storageLimit(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const _StorageLimitDialog(),
  );
}

class _StorageLimitDialog extends StatefulWidget {
  const _StorageLimitDialog({Key? key}) : super(key: key);

  @override
  State<_StorageLimitDialog> createState() => _StorageLimitDialogState();
}

class _StorageLimitDialogState extends State<_StorageLimitDialog> {
  double value = 50;
  final storage = locator.get<StorageHelper>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      value = (await storage.getStorageLimit()).toDouble();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Storage limit'),
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
          child: Image.asset(
            'assets/storage_limit.png',
          ),
        ),
      ),
      content: SizedBox(
        height: 80,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Limit',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  '${value.toInt()}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            Slider(
              value: value,
              label: '$value',
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
              min: 50,
              max: 1000,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            await storage.changeStorageLimit(value.toInt());
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
