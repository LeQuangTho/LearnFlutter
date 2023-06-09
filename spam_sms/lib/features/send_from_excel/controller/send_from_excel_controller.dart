import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/app_snack_bar/app_snack_bar.dart';
import 'package:spam_sms/core/models/selection_model.dart';
import 'package:spam_sms/core/theme/gen/colors.gen.dart';
import 'package:spam_sms/core/utils/app_util.dart';
import 'package:spam_sms/core/utils/permission_util.dart';
import 'package:spam_sms/features/send_from_excel/view/bottom_sheets/bts_phone_number_error.dart';

class SendFromExcelController extends GetxController {
  Rxn<PlatformFile> fileSelected = Rxn<PlatformFile>();
  RxList<SelectionModel<String>> phoneNumbers = <SelectionModel<String>>[].obs;
  RxBool canSendSMSMessage = false.obs;
  RxBool sendDirect = true.obs;

  late TextEditingController messageCTL;

  @override
  Future<void> onInit() async {
    super.onInit();
    messageCTL = TextEditingController();
    await checkCanSentSMS();
  }

  Future<void> importFromExcel() async {
    final resPick = await pickFile();

    if (resPick) {
      readPhoneNumberFromFile();
      checkPhoneNumber();
    }
  }

  Future<bool> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    fileSelected.value = result?.files.first;

    return fileSelected.value != null;
  }

  void readPhoneNumberFromFile() {
    if (fileSelected.value == null ||
        !File(fileSelected.value?.path ?? '').existsSync()) {
      AppSnackBar.showError('Lỗi đọc file');
    }
    final bytes = File(fileSelected.value!.path!).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    phoneNumbers.clear();

    for (final table in excel.tables.keys) {
      if (excel.tables[table] == null) {
        continue;
      }

      for (final row in excel.tables[table]!.rows) {
        final String phoneNumber =
            '${row.first?.value ?? ''}'.removeAllWhitespace;

        if (phoneNumber.isNotEmpty) {
          phoneNumbers.add(
            SelectionModel<String>(value: phoneNumber)..selected.value = true,
          );
        }
      }
    }
  }

  void checkPhoneNumber() {
    final List<String> phoneNumberError = [];

    for (int i = 0; i < phoneNumbers.length; i++) {
      if (!AppUtil.regExpPhoneNumber.hasMatch(phoneNumbers[i].value)) {
        phoneNumberError.add(phoneNumbers[i].value);
        phoneNumbers.removeAt(i);
      }
    }

    if (phoneNumberError.isNotEmpty) {
      Get.bottomSheet<dynamic>(
        BTSPhoneNumberError(data: phoneNumberError),
        backgroundColor: AppColor.white,
      );
    }
  }

  void removeAll() {
    phoneNumbers.clear();
    fileSelected.value = null;
    AppSnackBar.showSuccess('Xoá thành công');
  }

  void selectValue(int index) => phoneNumbers[index].selected.toggle();

  void changeSendDirect(bool _) => sendDirect.toggle();

  Future<void> checkCanSentSMS() async {
    canSendSMSMessage.value =
        await PermissionUtil.requestSMSPermission() && await canSendSMS();
  }

  Future<void> send() async {
    await checkCanSentSMS();
    if (canSendSMSMessage.isFalse) {
      return;
    }

    final recipients = phoneNumbers
        .where((element) => element.selected.isTrue)
        .map((e) => e.value)
        .toList();

    if (recipients.isNotEmpty) {
      try {
        final String _result = await sendSMS(
          message: messageCTL.text,
          recipients: recipients,
          sendDirect: sendDirect.isTrue,
        );

        AppSnackBar.showSuccess(_result.toString());
      } catch (error) {
        AppSnackBar.showError(error.toString());
      }
    }
  }
}
