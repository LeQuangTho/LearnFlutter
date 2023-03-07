import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../../navigations/app_pages.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../buttons/button_pop.dart';
import '../buttons/button_primary.dart';

class DialogConfirm extends StatelessWidget {
  String title;
  String body;
  String? textConfirm;
  String? textClose;
  Function action;
  DialogConfirm(
      {Key? key,
      required this.title,
      required this.body,
      this.textConfirm,
      required this.action,
      this.textClose})
      : super(key: key);

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
              title,
              style: AppTextStyle.textStyle.s16().w700().cN5(),
            ),
            SizedBox(height: 16.px),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTextStyle.textStyle.s12().w400().cN5(),
            ),
            SizedBox(height: 16.px),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: ButtonPop2(
                      buttonTitle: textClose ?? 'Hủy bỏ',
                      colorButton: ColorsPrimary.Lv5,
                      colorText: ColorsPrimary.Lv1,
                      height: 42.px,
                    ),
                  ),
                  SizedBox(width: 8.px),
                  Expanded(
                    child: ButtonPrimary(
                      height: 42.px,
                      padding: EdgeInsets.zero,
                      content: textConfirm ?? 'Xác nhận',
                      onTap: () {
                        AppNavigator.pop();
                        action();
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
