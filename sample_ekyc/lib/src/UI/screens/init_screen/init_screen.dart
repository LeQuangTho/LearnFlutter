import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 44.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Container(
              padding: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.px),
              ),
              child: SvgPicture.asset(
                AppAssetsLinks.LOGO,
                width: 150.px,
                height: 150.px,
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: 15.px),
              child: SpinKitFadingFour(
                size: 20.px,
                color: ColorsPrimary.Lv1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
