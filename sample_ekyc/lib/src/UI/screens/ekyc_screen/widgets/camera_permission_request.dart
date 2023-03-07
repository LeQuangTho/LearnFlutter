import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../helpers/untils/logger.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class PermissionCameraRequest extends StatelessWidget {
  const PermissionCameraRequest({Key? key}) : super(key: key);

  void askPermission() async {
    PermissionStatus status = await Permission.camera.request();
    UtilLogger.log('PermissionStatus Status', '$status');
    switch (status) {
      case PermissionStatus.granted:
        AppNavigator.replaceWith(Routes.CARD_FRONT_VALIDATION);
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssetsLinks.background_otp_sc,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 86.px),
                  SvgPicture.asset(AppAssetsLinks.permission_camera),
                  SizedBox(height: 16.px),
                  Text(
                    'Yêu cầu truy cập',
                    style: AppTextStyle.textStyle.s24().w700().cN5(),
                  ),
                  SizedBox(height: 8.px),
                  Text(
                    '$UNIT_NAME_CAP eSign cần quyền truy cập vào máy ảnh và micro của bạn để thực hiện quá trình xác thực. Ứng dụng sẽ yêu cầu bạn xác nhận quyết định này để sử dụng.',
                    style: AppTextStyle.textStyle.s16().w400().cN4(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ButtonPrimary(
              content: 'Cho phép',
              onTap: askPermission,
            ),
          ],
        ),
      ),
    );
  }
}
