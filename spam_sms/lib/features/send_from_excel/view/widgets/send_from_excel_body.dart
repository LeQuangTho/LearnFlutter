import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/theme/gen/colors.gen.dart';
import 'package:spam_sms/features/send_from_excel/controller/send_from_excel_controller.dart';

class SendFromExcelBody extends GetView<SendFromExcelController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: const Text('Có thể gửi tin nhắn SMS không?'),
                subtitle: Obx(() => Text(
                      controller.canSendSMSMessage.value
                          ? 'Có thể gửi tin nhắn SMS'
                          : 'Không hỗ trợ gửi tin nhắn SMS',
                      style: TextStyle(
                        color: controller.canSendSMSMessage.value
                            ? AppColor.green400
                            : AppColor.red400,
                      ),
                    )),
                trailing: IconButton(
                  icon: const Icon(Icons.change_circle, size: 40),
                  onPressed: controller.checkCanSentSMS,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              if (GetPlatform.isAndroid)
                Obx(() => SwitchListTile(
                      title: const Text('Gửi bằng ứng dụng mặc định'),
                      subtitle: const Text(
                        'Bạn có muốn gửi tin nhắn bằng ứng dụng mặc định không (Chỉ có trên Android)',
                      ),
                      value: !controller.sendDirect.isTrue,
                      onChanged: controller.changeSendDirect,
                      contentPadding: EdgeInsets.zero,
                    )),
              const SizedBox(height: 16),
              if (controller.phoneNumbers.isNotEmpty)
                TextField(
                  maxLines: 5,
                  minLines: 1,
                  controller: controller.messageCTL,
                  decoration: InputDecoration(
                    hintText: 'Nhập nội dung tin nhắn',
                    labelText: 'Nội dung tin nhắn',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: const Icon(Icons.message_outlined),
                    suffixIcon: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: controller.send,
                      child: const Icon(Icons.send),
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
