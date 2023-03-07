import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../../configs/languages/localization.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../buttons/button_pop.dart';

class DialogPop extends StatelessWidget {
  const DialogPop({
    Key? key,
    this.routeName,
  }) : super(key: key);
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsDark.Lv4,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.px),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.px),
            decoration: BoxDecoration(
              color: ColorsSupport.dialogColor,
              borderRadius: BorderRadius.circular(
                32.px,
              ),
            ),
            child: _buildDialogContentLayout(),
          ),
        ),
      ),
    );
  }

  Column _buildDialogContentLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30.px,
          ),
          child: SvgPicture.asset(
            AppAssetsLinks.ic_warning,
            height: 120.px,
            width: 120.px,
            fit: BoxFit.cover,
            color: ColorsYellow.Y5,
          ),
        ),
        Container(
          height: 66.px,
          child: Text(
            StringKey.duplicateAccountNoti.tr,
            style: AppTextStyle.textStyle.s16().w400().cN2(),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.px),
          child: ButtonPop(
            buttonTitle: StringKey.backToLoginScreen.tr,
            routeName: routeName,
            // Adding route name
          ),
        ),
      ],
    );
  }
}
