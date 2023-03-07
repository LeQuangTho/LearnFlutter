import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ChangePasswordFail extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const ChangePasswordFail({
    Key? key,
    required this.arguments,
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
                      'Đổi mật khẩu\nkhông thành công',
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      'Đã có sự cố xảy ra trong quá trình thay đổi mật khẩu',
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
                  if (arguments['typeChangePassword'] == 'afterLogin') {
                    AppNavigator.popUntil(Routes.CHANGE_PASSWORD_AFTER_LOGIN);
                  } else {
                    AppNavigator.pushNamedAndRemoveUntil(
                        Routes.FORGOT_PASSWORD);
                  }
                },
              ),
              SizedBox(
                height: 8.px,
              ),
              ButtonPop2(
                buttonTitle: arguments['typeChangePassword'] == 'afterLogin'
                    ? 'Về màn hình chính'
                    : 'Đăng nhập',
                onTap: () {
                  if (arguments['typeChangePassword'] == 'afterLogin') {
                    AppNavigator.popUntil(Routes.HOME);
                  } else {
                    AppNavigator.pushNamedAndRemoveUntil(Routes.LOGIN);
                  }
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
