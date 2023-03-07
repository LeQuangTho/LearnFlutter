import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../helpers/geolocator_helper.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';

class DialogServiceLocation extends StatelessWidget {
  bool isSign;
  DialogServiceLocation({Key? key, required this.isSign}) : super(key: key);

  bool isRequest = false;

  Future<void> _request_permission(context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    print(">>>>> $permission");

    if (permission == LocationPermission.always) {
      AppBlocs.authenticationBloc
          .add(AuthenticationAddFirebaseTokenEnableLocationEvent());
      AppNavigator.pop();
    } else if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
    } else if (permission == LocationPermission.whileInUse) {
      if (isSign) {
        AppNavigator.pop();
        AppNavigator.pop();
        AppBlocs.userRemoteBloc.add(UserRemoteSigningEFormEvent());
      } else {
        AppNavigator.pop();
        AppBlocs.authenticationBloc
            .add(AuthenticationAddFirebaseTokenEnableLocationEvent());
      }
    } else {
      await GeolocatorHelper().getCurrentPosition().then((value) async {
        if (value != null) {
          AppBlocs.authenticationBloc
              .add(AuthenticationAddFirebaseTokenEnableLocationEvent());
          AppNavigator.pop();
        } else {
          if (isSign) {
            await openAppSettings();
          } else {
            AppNavigator.pop();
          }
        }
      });
    }
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
                AppNavigator.pop();
              },
              child: SvgPicture.asset(AppAssetsLinks.ic_close_border),
            ),
          ),
          SizedBox(
            width: 12.px,
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            AppAssetsLinks.background_otp_sc,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: kToolbarHeight + 62.px),
                        Text(
                          "Chia sẻ vị trí \n của bạn với $UNIT_NAME_CAP",
                          style: AppTextStyle.textStyle.s24().w700().cN5(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 57.px),
                        SvgPicture.asset(
                          AppAssetsLinks.image_location,
                          width: 200.px,
                          height: 200.px,
                        ),
                        SizedBox(height: 57.px),
                        Text(
                          "Cho phép ứng dụng truy cập vị trí của bạn để ký hợp đồng với $UNIT_NAME_CAP",
                          style: AppTextStyle.textStyle.s16().w400().cN3(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // AppNavigator.pop();
                  },
                  child: ButtonPrimary(
                    padding: EdgeInsets.only(top: 10, bottom: 42),
                    content: "Cho phép",
                    // enable: isRequest,
                    onTap: isRequest
                        ? () {}
                        : () async {
                            isRequest = true;
                            await _request_permission(context);
                            isRequest = false;
                            // await openAppSettings();
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DialogBiometric extends StatelessWidget {
  const DialogBiometric({Key? key, required this.title, required this.body})
      : super(key: key);
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        color: ColorsDark.Lv2.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.px, vertical: 10.px),
              width: 100.w - 40.px,
              decoration: BoxDecoration(
                color: ColorsWhite.Lv1,
                borderRadius: BorderRadius.circular(16.px),
              ),
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 10.px),
                  //   child: SvgPicture.asset((AppBlocs.localAuthBloc.biometricTypes
                  //       .isNotEmpty &&
                  //       AppBlocs.localAuthBloc.biometricTypes
                  //           .contains(BiometricType.face)) ? AppAssetsLinks.ic_face_id :  AppAssetsLinks.ic_finger,width: 60,height: 60,),
                  // ),
                  title.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.px, vertical: 8.px),
                          child: Text(
                            title,
                            style: AppTextStyle.textStyle.s16().w700().cN5(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox(),
                  body.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.px, vertical: 15.px),
                          child: Text(
                            body,
                            style: AppTextStyle.textStyle.s14().w400().cN5(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 161.px,
                    child: ButtonPrimary(
                      height: 56.px,
                      padding: EdgeInsets.only(bottom: 15),
                      content: "Đóng",
                      onTap: () {
                        AppNavigator.pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
