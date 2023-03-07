import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_pop.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/splash_layout.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../../configs/languages/localization.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../designs/app_themes/app_text_styles.dart';


class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({Key? key}) : super(key: key);

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashLayout(
      appbarEnable: false,
      body: Column(
        children: [
          SizedBox(
            height: 25.px,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              StringKey.preLoginTitle.tr,
              style: AppTextStyle.textStyle.s30().w700().cN5(),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 25.px,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              StringKey.preLoginBody.tr,
              style: AppTextStyle.textStyle.s16().w400().cN3(),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 25.px,
          ),
          Expanded(
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0.px),
                    ),
                    child: SvgPicture.asset(AppAssetsLinks.img_pre_login))),
          ),
          ButtonPrimary(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            onTap: () {
              AppNavigator.pushNamedAndRemoveUntil(Routes.LOGIN);
            },
            content: StringKey.preLoginSignIn.tr,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.px, bottom: 22.px),
            child: Center(
              child: Text(
                'Bạn chưa có tài khoản?',
                style: AppTextStyle.textStyle.s16().w400().cN3(),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: ButtonPop2(
              colorButton: ColorsGray.Lv3,
              onTap: () {},
              buttonTitle: StringKey.preLoginRegisterNow.tr,
            ),
          ),
          SizedBox(height: 42.px),
        ],
      ),
    );
  }
}
