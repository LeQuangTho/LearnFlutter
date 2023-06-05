import 'package:get/get.dart';
import 'package:spam_sms/features/send_from_excel/controller/send_from_excel_controller.dart';

class SendFromExcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SendFromExcelController.new);
  }
}
