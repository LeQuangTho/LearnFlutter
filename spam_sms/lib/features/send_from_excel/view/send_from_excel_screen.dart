import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/common_layout/base_scaffold.dart';
import 'package:spam_sms/core/components/divider_components/vertical_divider.dart';
import 'package:spam_sms/core/theme/gen/assets.gen.dart';
import 'package:spam_sms/core/theme/gen/colors.gen.dart';
import 'package:spam_sms/features/send_from_excel/controller/send_from_excel_controller.dart';
import 'package:spam_sms/features/send_from_excel/view/widgets/list_phone_number.dart';
import 'package:spam_sms/features/send_from_excel/view/widgets/send_from_excel_body.dart';

class SendFromExcelScreen extends GetView<SendFromExcelController> {
  const SendFromExcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text('Gửi SMS với file Excel')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Expanded(child: ListPhoneNumber()),
              const VerticalDividerCustom(),
              Expanded(child: SendFromExcelBody()),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(() => Visibility(
                        visible: controller.phoneNumbers.isNotEmpty,
                        child: ElevatedButton.icon(
                          onPressed: controller.removeAll,
                          label: const Text('Xoá hết'),
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.red100,
                          ),
                        ),
                      )),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: controller.importFromExcel,
                    label: const Text('Chọn file Excel'),
                    icon: Assets.icons.icExcel.svg(height: 24),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
