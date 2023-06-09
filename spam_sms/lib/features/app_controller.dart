import 'package:get/get.dart';
import 'package:spam_sms/core/utils/device_info_helper.dart';
import 'package:spam_sms/core/utils/logger_util.dart';
import 'package:spam_sms/features/send_from_excel/controller/send_from_excel_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..put(AppController.new)
      ..lazyPut(SendFromExcelController.new);
  }
}

class AppController extends GetxController {
  @override
  Future<void> onInit() async {
    await DeviceInfoHelper.initPlatformState().then((_) => logger.d(
          'Khởi tạo thông tin thiết bị',
        ));
    super.onInit();
  }
}
