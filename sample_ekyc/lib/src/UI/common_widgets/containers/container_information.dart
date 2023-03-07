import 'package:flutter/material.dart';

import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

class ContainerInformation extends StatelessWidget {
  const ContainerInformation({
    Key? key,
    this.isSexContainer,
    required this.labeltext,
    required this.contentText,
  }) : super(key: key);
  final bool? isSexContainer;
  final String labeltext;
  final String? contentText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.px,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 9.px),
        width: double.infinity,
        // height: 56.px,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.px),
          color: ColorsWhite.Lv4,
          border: Border.all(color: ColorsNeutral.Lv4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labeltext,
              style: AppTextStyle.textStyle.s12().w500().cN2(),
            ),
            (contentText == null)
                ? SizedBox()
                : Container(
                    child: Text(
                      contentText!,
                      style: AppTextStyle.textStyle.s16().w500().cN2(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
