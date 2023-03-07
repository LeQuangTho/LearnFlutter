import 'package:flutter/material.dart';

import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../../configs/languages/localization.dart';
import '../../designs/app_background.dart';

class RegisterSucceedScreen extends StatelessWidget {
  const RegisterSucceedScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundStack(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.px,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          StringKey.createAccountSucceed.tr,
                          style: AppTextStyle.textStyle.s24().w600().cW5(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30.px,
                      ),
                      Image.asset(
                        AppAssetsLinks.ic_tick_circle,
                        height: 150.px,
                        width: 150.px,
                        fit: BoxFit.fill,
                      )
                    ],
                  ),
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppNavigator.pushNamedAndRemoveUntil(Routes.LOGIN);
                },
                content: StringKey.login.tr,
              )
            ],
          ),
        ),
      ),
    );
  }
}
