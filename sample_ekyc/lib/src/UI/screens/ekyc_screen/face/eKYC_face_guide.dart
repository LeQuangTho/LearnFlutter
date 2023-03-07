import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';


import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../widgets/guide_step.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';


// ignore: must_be_immutable
class EKYCFaceGuide extends StatefulWidget {
  SdkConfig? sdkConfig;
  EKYCFaceGuide({required this.sdkConfig, Key? key}) : super(key: key);

  @override
  State<EKYCFaceGuide> createState() => _EKYCFaceGuideState();
}

class _EKYCFaceGuideState extends State<EKYCFaceGuide> {

  @override
  void initState() {
    super.initState();
    initSdkConfig();
  }

  void initSdkConfig() {
    if (widget.sdkConfig != null && !AppConfig.isInit) {
      AppConfig.isInit = true;
      AppConfig().source = widget.sdkConfig!.source;
      AppConfig().apiUrl = widget.sdkConfig!.apiUrl;
      AppConfig().token = widget.sdkConfig!.token;
      AppConfig().timeOut = widget.sdkConfig!.timeOut;
      AppConfig().email = widget.sdkConfig!.email;
      AppConfig().phone = widget.sdkConfig!.phone;
      AppConfig().backRoute = widget.sdkConfig!.backRoute;
      AppConfig().sdkCallback = widget.sdkConfig!.sdkCallback;
    }
  }

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
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.px, vertical: 12.px),
                      decoration: BoxDecoration(
                        color: ColorsSuccess.Lv5,
                        borderRadius: BorderRadius.circular(10.px),
                        border: Border.all(
                          color: ColorsSuccess.Lv1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppAssetsLinks.face_gr),
                          SizedBox(width: 8.px),
                          Text(
                            'Đã ghi nhận dữ liệu giấy tờ',
                            style: AppTextStyle.textStyle.s16().w700().cN5(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.px),
                    Text(
                      'Chụp ảnh khuôn mặt',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    SizedBox(height: 8.px),
                    Text(
                      'Theo quy định của pháp luật, bạn cần cung cấp hình ảnh khuôn mặt để được xác minh và cấp chứng thư số.',
                      style: AppTextStyle.textStyle.s16().w400().cN4(),
                    ),
                    GuideSteps(
                      steps: [
                        'Giữ điện thoại ổn định và thẳng khuôn mặt.',
                        'Thực hiện chụp ảnh chính diện khuôn mặt để hoàn thành việc xác thực.',
                        'Đảm bảo hình ảnh được chụp trong điều kiện đầy đủ ánh sáng, rõ nét.',
                      ],
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  // AppNavigator.push(Routes.EKYC_FACE);

                  // AppNavigator.push(Routes.FACE_VALIDATION_VIEW);
                },
                content: 'Tiếp tục',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
