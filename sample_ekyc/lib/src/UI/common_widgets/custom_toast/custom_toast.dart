import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';
import '../dialogs/show_dialog_animations.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    Key? key,
    this.title,
    this.body,
    required this.type,
  }) : super(key: key);
  final String? title;
  final String? body;
  final ToastType type;

  @override
  Widget build(BuildContext context) {
    Color buildBackgroundColor() {
      switch (type) {
        case ToastType.error:
          return ColorsPrimary.Lv1;
        case ToastType.success:
          return ColorsSuccess.Lv1;
        case ToastType.warning:
          return ColorsWarn.Lv2;
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.px),
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 50.px,
            ),
            Center(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.px, vertical: 10.px),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.px),
                  color: buildBackgroundColor(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssetsLinks.error,
                      height: 20.px,
                    ),
                    SizedBox(
                      width: 12.px,
                    ),
                    Flexible(
                      child: Text(
                        title ?? '',
                        style: AppTextStyle.textStyle.s16().w500().cW5(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
