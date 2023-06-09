import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/components/divider_components/vertical_divider.dart';
import 'package:spam_sms/features/send_from_excel/controller/send_from_excel_controller.dart';
import 'package:spam_sms/features/send_from_excel/view/widgets/demo_panel.dart';

class ListPhoneNumber extends GetView<SendFromExcelController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      // ignore: invalid_use_of_protected_member
      () => controller.phoneNumbers.value.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (_, __) => const VerticalDividerCustom(
                height: 0.5,
              ),
              itemCount: controller.phoneNumbers.length,
              itemBuilder: (context, index) {
                return Obx(() => ListTile(
                      leading: Checkbox(
                        value: controller.phoneNumbers[index].selected.isTrue,
                        onChanged: (value) => controller.selectValue(index),
                      ),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        controller.phoneNumbers[index].value,
                      ),
                    ));
              },
            )
          : const DemoPanel(),
    );
  }
}
