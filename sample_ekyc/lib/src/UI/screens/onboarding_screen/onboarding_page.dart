import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../designs/app_themes/app_text_styles.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40.px,
        ),
        Expanded(
          child: Center(
            child: SvgPicture.asset(
              image,
            ),
          ),
        ),
        SizedBox(
          height: 32.px,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Text(
            title,
            style: AppTextStyle.textStyle.s40().w700().cN5(),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 16.px,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Text(
            desc,
            style: AppTextStyle.textStyle.s16().w400().cN3(),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
