import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/common_layout/base_scaffold.dart';
import 'package:spam_sms/features/send_from_excel/controller/send_from_excel_controller.dart';

class SendFromExcelScreen extends GetView<SendFromExcelController> {
  const SendFromExcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text('SMS/MMS Spam')),
      body: const Placeholder(),
    );
  }
}
