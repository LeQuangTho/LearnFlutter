import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../../configs/languages/localization.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../common_widgets/check_box/check_box.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';

class SmartOTPScreen extends StatefulWidget {
  const SmartOTPScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<SmartOTPScreen> createState() => _SmartOTPScreenState();
}

class _SmartOTPScreenState extends State<SmartOTPScreen> {
  bool _isCheck = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                AppBlocs.authenticationBloc.add(AuthenticationLogOutEvent());
              },
              child: SvgPicture.asset(AppAssetsLinks.ic_close_border),
            ),
          ),
          SizedBox(
            width: 12.px,
          )
        ],
      ),
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
                  children: [
                    SizedBox(
                      height: 100.px,
                    ),
                    Text(
                      StringKey.smartOtpGuideTitle.tr,
                      style: AppTextStyle.textStyle.s24().w700().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.px),
                      child: SvgPicture.asset(AppAssetsLinks.pin_undone),
                    ),
                    Text(
                      StringKey.smartOtpGuideDesc.tr,
                      style: AppTextStyle.textStyle.s16().w400().cN4(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.px),
                    color: _isCheck ? ColorsSuccess.Lv5 : null),
                child: Row(
                  children: [
                    CheckBoxCustom(
                      isChecked: _isCheck,
                      onPress: (v) {
                        setState(() {
                          _isCheck = !_isCheck;
                        });
                      },
                    ),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: StringKey.agreeWith.tr,
                          style: AppTextStyle.textStyle.s16().w400().cN5(),
                          children: [
                            TextSpan(
                              text: 'Điều khoản và điều kiện sử dụng Smart OTP',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  AppNavigator.push(
                                    Routes.ASSETS_PDF_VIEW,
                                    arguments: {
                                      'assetsFilePath':
                                          TERMS_AND_CONDITIONS_SMART_OTP
                                    },
                                  );
                                },
                              style: AppTextStyle.textStyle
                                  .s16()
                                  .w700()
                                  .cN5()
                                  .underline(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.px,
              ),
              ButtonPrimary(
                padding: EdgeInsets.zero,
                onTap: () => AppNavigator.push(Routes.SET_PINCODE),
                content: 'Tiếp tục',
                enable: _isCheck,
              ),
              SizedBox(
                height: 42.px,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
