import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/authentication/authentication_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

class ActiveDeviceScreen extends StatelessWidget {
  final String username;
  ActiveDeviceScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            AppAssetsLinks.background_otp_sc,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.px),
                    child: Column(
                      children: [
                        SizedBox(height: kToolbarHeight + 62.px),
                        SvgPicture.asset(
                          AppAssetsLinks.device_otp,
                          width: 200.px,
                          height: 200.px,
                        ),
                        Text(
                          "Tích hợp Smart OTP",
                          style: AppTextStyle.textStyle.s24().w700().cN5(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.px),
                        Text(
                          "Bạn đang đăng nhập trên thiết bị mới. Vì lý do bảo mật, Bạn cần tích hợp Smart OTP trên thiết bị này!",
                          style: AppTextStyle.textStyle.s16().w400().cN3(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.px),
                child: ButtonPrimary(
                  content: "Tích hợp ngay",
                  onTap: () {
                    AppBlocs.authenticationBloc.add(
                      AuthenticationGetOTPEvent(
                        userName: username,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
