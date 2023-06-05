import 'package:get/route_manager.dart';
import 'package:spam_sms/core/routes/app_routes.dart';
import 'package:spam_sms/features/send_from_excel/bindings/send_from_excel_binding.dart';
import 'package:spam_sms/features/send_from_excel/view/send_from_excel_screen.dart';

mixin AppScreens {
  static final pages = [
    GetPage<dynamic>(
      name: AppRoutes.sendFromExcel,
      page: SendFromExcelScreen.new,
      binding: SendFromExcelBinding(),
    ),
  ];
}
