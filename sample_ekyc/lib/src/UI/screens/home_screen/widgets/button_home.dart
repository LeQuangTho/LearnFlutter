import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../extentions/typedef.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ButtonHome extends StatelessWidget {
  const ButtonHome({
    Key? key,
    required this.title,
    required this.onTap,
    this.countNum,
    this.widgetBio,
    this.isBiometric,
    required this.icon,
    this.titleStyle,
    this.isRound = false,
    this.shadow = false,
  }) : super(key: key);

  ButtonHome.round({
    Key? key,
    required this.title,
    required this.onTap,
    this.countNum,
    this.isBiometric,
    this.widgetBio,
    required this.icon,
    this.isRound = true,
    this.titleStyle,
    this.shadow = false,
  });

  ButtonHome.shadow({
    Key? key,
    required this.title,
    required this.onTap,
    this.countNum,
    this.widgetBio,
    this.isBiometric,
    required this.icon,
    this.titleStyle,
    this.isRound = false,
    this.shadow = true,
  });

  final String title;
  final Callback? onTap;
  final String? countNum;
  final String icon;
  final Widget? widgetBio;
  final bool isRound;
  final bool? isBiometric;
  final TextStyle? titleStyle;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: isRound ? BorderRadius.circular(10.px) : null,
            color: ColorsLight.Lv1,
            boxShadow: shadow
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]
                : null),
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 20.px),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(icon),
                  SizedBox(
                    width: 16.px,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: titleStyle ??
                          AppTextStyle.textStyle.s16().w500().cN5(),
                    ),
                  ),
                ],
              ),
            ),
            if (countNum != null && countNum != 'null' && countNum != '0')
              ClipOval(
                child: Container(
                  width: 24.px,
                  height: 24.px,
                  color: ColorsPrimary.Lv1,
                  child: Center(
                    child: Text(
                      countNum!,
                      style: AppTextStyle.textStyle.s12().w500().cW5(),
                    ),
                  ),
                ),
              )
            else
              (isBiometric == true
                  ? widgetBio ?? SizedBox.shrink()
                  : SvgPicture.asset(AppAssetsLinks.ic_arrow_open)),
          ],
        ),
      ),
    );
  }
}
