import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../common_widgets/buttons/button_primary.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_text_styles.dart';

class SuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? arguments;
  const SuccessScreen({
    Key? key,
    required this.arguments,
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
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAssetsLinks.success_cloud),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      arguments!['titleSuccess'],
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      arguments!['contentSuccess'],
                      style: AppTextStyle.textStyle.s16().w400().cN2(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: arguments!['actionSuccess'],
                content: arguments!['textButtonSuccess'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
