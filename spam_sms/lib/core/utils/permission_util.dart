import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spam_sms/core/app_snack_bar/app_snack_bar.dart';
import 'package:spam_sms/core/utils/device_info_helper.dart';

mixin PermissionUtil {
  static Future<bool> requestStoragePermission() async {
    if (GetPlatform.isAndroid && DeviceInfoHelper.sdkVersionInt() == 33) {
      return true;
    }

    return request(Permission.storage);
  }

  static Future<bool> requestSMSPermission() async {
    final bool result = await PermissionUtil.request(Permission.sms);

    if (!result) {
      AppSnackBar.showWarning('Bạn chưa cấp quyền gửi tin nhắn cho ứng dụng!');
    }

    return result;
  }

  static Future<bool> request(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else if (await permission.isPermanentlyDenied) {
      await openAppSettings();

      return permission.isGranted;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }

    return false;
  }
}
