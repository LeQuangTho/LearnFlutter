import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ChangePinFail extends StatelessWidget {
  const ChangePinFail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    SvgPicture.asset(AppAssetsLinks.failed_cloud),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      'Đổi mã PIN\nkhông thành công',
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      'Đã có sự cố xảy ra trong quá trình thay đổi mã PIN',
                      style: AppTextStyle.textStyle.s16().w400().cN2(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                padding: EdgeInsets.zero,
                content: 'Thực hiện lại',
                onTap: () {
                  AppNavigator.pushNamedAndRemoveUntil(Routes.OLD_PIN_CONFIRM);
                },
              ),
              SizedBox(
                height: 8.px,
              ),
              ButtonPop2(
                buttonTitle: 'Về màn hình chính',
                onTap: () {
                  AppNavigator.pushNamedAndRemoveUntil(Routes.HOME);
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
