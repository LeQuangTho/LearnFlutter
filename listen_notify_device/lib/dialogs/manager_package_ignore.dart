import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data/storage_helper.dart';

managerPackageIgnore(BuildContext context) async {
  showDialog(
    context: context,
    builder: (_) => const _ManagerPackageDialog(),
  );
}

class _ManagerPackageDialog extends StatefulWidget {
  const _ManagerPackageDialog({Key? key}) : super(key: key);

  @override
  State<_ManagerPackageDialog> createState() => _ManagerPackageDialogState();
}

class _ManagerPackageDialogState extends State<_ManagerPackageDialog> {
  final storage = StorageHelper();
  List<String> packages = [];
  List<String> packagesDelete = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      packages = await storage.getFilterPackage();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quản lí package'),
      icon: Center(
        child: Container(
          height: 50,
          width: 50,
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
          child: Image.asset('assets/notification.png'),
        ),
      ),
      content: SizedBox(
        height: 40.h,
        width: 80.w,
        child: packages.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) => CheckboxListTile(
                  value: packagesDelete.contains(packages[index]),
                  onChanged: (value) {
                    if ((value ?? false)) {
                      packagesDelete.add(packages[index]);
                    } else {
                      packagesDelete.remove(packages[index]);
                    }
                    setState(() {});
                  },
                  title: Text(packages[index]),
                ),
                itemCount: packages.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 1,
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
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: packagesDelete.isNotEmpty
              ? () async {
                  storage.deletePackageIgnore(packagesDelete);
                  packages = await storage.getFilterPackage();
                  setState(() {});
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
