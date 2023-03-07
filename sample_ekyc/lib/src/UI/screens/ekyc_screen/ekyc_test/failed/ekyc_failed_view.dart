import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_pop.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/helpers/untils/logger.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

class EkycFailedView extends StatelessWidget {
  const EkycFailedView({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    UtilLogger.log('EkycFailedView Message', '$message');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssetsLinks.background_otp_sc,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAssetsLinks.validation_failed),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      'Không thành công',
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      message ??
                          'Dữ liệu khuôn mặt không trùng khớp với giấy tờ đã chụp',
                      style: AppTextStyle.textStyle.s16().w400().cN2(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                padding: EdgeInsets.zero,
                content: 'Xác thực lại',
                onTap: () {
                  UtilLogger.log('EkycFailedView', 'Xác thực lại');
                  AppNavigator.popUntil(Routes.EKYC);
                },
              ),
              SizedBox(
                height: 8.px,
              ),
              ButtonPop2(
                buttonTitle: 'Thoát',
                onTap: () {
                  UtilLogger.log('EkycFailedView', 'Thoát');
                  AppNavigator.popUntil(Routes.DIGITAL_CERTIFICATE);
                },
              ),
              SizedBox(
                height: 24.px,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
