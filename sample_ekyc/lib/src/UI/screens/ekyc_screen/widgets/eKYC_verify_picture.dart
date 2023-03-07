import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../home_screen/widgets/button_home.dart';
import 'guide_step.dart';

class EKYCVerifyPicture extends StatelessWidget {
  const EKYCVerifyPicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundStack(
      child: Scaffold(
        appBar: MyAppBar(''),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.px),
                    Text(
                      'Chụp ảnh giấy tờ',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      'Bạn vui lòng chọn 1 loại giấy tờ tùy thân để xác thực thông tin.',
                      style: AppTextStyle.textStyle.s16().w400().cN4(),
                    ),
                    SizedBox(height: 32.px),
                    ButtonHome.shadow(
                      title: 'CMND/CCCD',
                      icon: AppAssetsLinks.identity_doc,
                      onTap: () async {
                        final isGranted =
                            await Permission.camera.status.isGranted;
                        if (isGranted) {
                          AppNavigator.push(Routes.CARD_FRONT_VALIDATION);
                        } else {
                          AppNavigator.push(Routes.PERMISSION_CAMERA_REQUEST);
                        }
                      },
                    ),
                    SizedBox(height: 8.px),
                    // ButtonHome.shadow(
                    //   title: 'Hộ chiếu',
                    //   icon: AppAssetsLinks.identity_doc,
                    //   onTap: () {
                    //     AppNavigator.push(Routes.EKYC_PASSPORT);
                    //   },
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 32.px),
                      child: Text(
                        'Những lưu ý trước khi chụp giấy tờ',
                        style: AppTextStyle.textStyle.s16().w700().cN5(),
                      ),
                    ),
                    GuideSteps(
                      steps: [
                        'Giấy tờ của bạn sẽ được chụp theo thứ tự mặt trước -> mặt sau.',
                        'Đảm bảo giấy tờ của bạn là chính chủ, còn hạn sử dụng và là bản gốc.',
                        'Đảm bảo hình ảnh được chụp rõ nét, hình ảnh của giấy tờ nằm trong vùng chọn.',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
