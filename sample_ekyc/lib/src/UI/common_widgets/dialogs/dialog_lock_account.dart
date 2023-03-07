import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../buttons/button_primary.dart';

class DialogLockAccount extends StatelessWidget {
  DialogLockAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsLight.Lv1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.px))),
      insetPadding: EdgeInsets.symmetric(horizontal: 42.px),
      child: Container(
        padding: EdgeInsets.all(20.px),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tài khoản đã bị khóa",
              style: AppTextStyle.textStyle.s16().w700().cN5(),
            ),
            SizedBox(height: 16.px),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text:
                      "Tài khoản của Bạn đã bị khóa do nhập sai quá 5 lần. Vui lòng liên hệ tổng đài ",
                  style: AppTextStyle.textStyle.s12().w400().cN5(),
                  children: [
                    TextSpan(
                      text: "1900",
                      style: AppTextStyle.textStyle.s12().w600().cN5(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: '$UNIT_PHONE',
                          );
                          await launch(launchUri.toString());
                        },
                    ),
                    TextSpan(
                      text: " để được hỗ trợ mở lại tài khoản.",
                      style: AppTextStyle.textStyle.s12().w400().cN5(),
                    )
                  ]),
            ),
            SizedBox(height: 16.px),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: ButtonPrimary(
                      height: 42.px,
                      padding: EdgeInsets.zero,
                      content: 'Đóng',
                      onTap: () {
                        AppNavigator.pop();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
