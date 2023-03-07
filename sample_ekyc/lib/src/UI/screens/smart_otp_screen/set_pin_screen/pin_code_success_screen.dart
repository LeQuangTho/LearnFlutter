import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../../../configs/languages/localization.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class PinCodeSuccessScreen extends StatelessWidget {
  const PinCodeSuccessScreen({
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
          child: Padding(
            padding: EdgeInsets.only(top: 76.px),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          StringKey.setPinSuccessTitle.tr,
                          style: AppTextStyle.textStyle.s24().w700().cN5(),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.px),
                          child: SvgPicture.asset(AppAssetsLinks.pin),
                        ),
                        Text(
                          StringKey.setPinSuccessDesc.tr,
                          style: AppTextStyle.textStyle.s16().w400().cN2(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonPrimary(
                  onTap: () {
                    AppNavigator.pushNamedAndRemoveUntil(Routes.HOME);
                  },
                  content: StringKey.home.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
