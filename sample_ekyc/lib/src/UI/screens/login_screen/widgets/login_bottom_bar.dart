import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class BottomButtonWidget extends StatelessWidget {
  const BottomButtonWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final String icon;
  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SvgPicture.asset(icon),
            SizedBox(
              height: 13.px,
            ),
            Text(
              title,
              style: AppTextStyle.textStyle.s12().w700().cN5(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBottomBar extends StatelessWidget {
  const LoginBottomBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12.px, 0, 24.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // BottomButtonWidget(
          //   icon: AppAssetsLinks.GUIDE,
          //   title: StringKey.guide.tr,
          //   onTap: () {
          //     AppNavigator.push(
          //       Routes.CONTENT,
          //       arguments: {'contentType': MedyChainContentType.guide},
          //     );
          //   },
          // ),
          // BottomButtonWidget(
          //   icon: AppAssetsLinks.ic_qrcode,
          //   title: StringKey.scanQr.tr,
          //   onTap: () {
          //     AppNavigator.push(
          //       Routes.CONTENT,
          //       arguments: {'contentType': MedyChainContentType.question},
          //     );
          //   },
          // ),
          BottomButtonWidget(
            icon: AppAssetsLinks.ic_hotline,
            title: 'Hotline',
            onTap: () async {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: '$UNIT_PHONE',
              );
              await launchUrlString(launchUri.toString());
            },
          ),
        ],
      ),
    );
  }
}
