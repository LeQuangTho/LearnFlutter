import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../configs/languages/localization.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ChangPasswordSuccess extends StatelessWidget {
  final Map<String, dynamic>? arguments;
  const ChangPasswordSuccess({
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
                    SvgPicture.asset(AppAssetsLinks.success_cloud),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      'Đổi mật khẩu thành công',
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      'Mật khẩu mới sẽ được áp dụng trong phiên đăng nhập kế tiếp',
                      style: AppTextStyle.textStyle.s16().w400().cN2(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  if (arguments?['typeChangePassword'] == 'afterLogin') {
                    AppNavigator.popUntil(Routes.HOME);
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    AppNavigator.pushNamedAndRemoveUntil(Routes.LOGIN);
                  }
                },
                content: arguments?['typeChangePassword'] == 'afterLogin'
                    ? 'Hoàn thành'
                    : StringKey.login.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
