import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../../BLOC/local_auth/local_auth_bloc.dart';
import '../../../BLOC/pin_code_bloc/pin_code_bloc.dart';
import '../../../constants/hard_constants.dart';
import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../../repositories/local/local_auth_repository.dart';
import '../../common_widgets/custom_switch/custom_switch.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';
import '../home_screen/widgets/button_home.dart';

class UserProfileBody extends StatelessWidget {
  const UserProfileBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isFaceID = AppBlocs.localAuthBloc.biometricTypes.isNotEmpty &&
        AppBlocs.localAuthBloc.biometricTypes.contains(BiometricType.face);
    return Padding(
      padding: EdgeInsets.only(
          top: kToolbarHeight + (Platform.isIOS ? 70.px : 50.px)),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.px)),
        child: Container(
          color: ColorsGray.Lv3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.px),
                Padding(
                  padding: EdgeInsets.only(left: 20.px),
                  child: Text(
                    'Cá nhân'.toUpperCase(),
                    style: AppTextStyle.textStyle.s12().w700().cN5(),
                  ),
                ),
                SizedBox(height: 16.px),
                ButtonHome(
                  title: 'Thông tin cá nhân',
                  icon: AppAssetsLinks.user_info,
                  onTap: () {
                    AppNavigator.push(Routes.USER_INFO);
                  },
                ),
                SizedBox(height: 16.px),
                Padding(
                  padding: EdgeInsets.only(left: 20.px),
                  child: Text(
                    'Smart OTP'.toUpperCase(),
                    style: AppTextStyle.textStyle.s12().w700().cN5(),
                  ),
                ),
                SizedBox(height: 16.px),
                ButtonHome(
                  icon: AppAssetsLinks.change_pin_code,
                  title: 'Thay đổi mã PIN',
                  onTap: () {
                    AppBlocs.pinCodeBloc.add(
                      PinCodeCheckLockEvent(
                        route: Routes.OLD_PIN_CONFIRM,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ButtonHome(
                  icon: AppAssetsLinks.forgot_pin_code,
                  title: 'Quên mã PIN',
                  onTap: () {
                    AppNavigator.push(Routes.FORGOT_PIN_CODE);
                  },
                ),
                const Divider(height: 1),
                ButtonHome(
                  icon: AppAssetsLinks.ic_device_manage,
                  title: 'Quản lý thiết bị',
                  onTap: () {
                    AppNavigator.push(Routes.DEVICE_MANAGEMENT);
                  },
                ),
                SizedBox(height: 16.px),
                Padding(
                  padding: EdgeInsets.only(left: 20.px),
                  child: Text(
                    'QUẢN LÝ CHỮ KÝ SỐ',
                    style: AppTextStyle.textStyle.s12().w700().cN5(),
                  ),
                ),
                SizedBox(height: 16.px),
                ButtonHome(
                  icon: AppAssetsLinks.chung_thu_so,
                  title: 'Chứng thư số',
                  onTap: () {
                    AppNavigator.push(Routes.DIGITAL_CERTIFICATE);
                  },
                ),
                SizedBox(height: 16.px),
                Padding(
                  padding: EdgeInsets.only(left: 20.px),
                  child: Text(
                    'Bảo mật'.toUpperCase(),
                    style: AppTextStyle.textStyle.s12().w700().cN5(),
                  ),
                ),
                SizedBox(height: 16.px),
                ButtonHome(
                  icon: AppAssetsLinks.change_password,
                  title: 'Thay đổi mật khẩu',
                  onTap: () {
                    AppNavigator.push(Routes.CHANGE_PASSWORD_AFTER_LOGIN);
                  },
                ),
                const Divider(height: 1),
                ButtonHome(
                  icon: isFaceID
                      ? AppAssetsLinks.ic_face_id
                      : AppAssetsLinks.ic_finger,
                  title: 'Đăng nhập với ' + (isFaceID ? "Face ID" : "Touch ID"),
                  onTap: null,
                  isBiometric: true,
                  widgetBio: BlocBuilder<LocalAuthBloc, LocalAuthState>(
                    builder: (context, state) {
                      if (state is LocalAuthUnAuthenticated) {
                        return CustomSwitch(
                          value: false,
                          onChanged: () async {
                            if (await UserPrivateRepo().authenticateUser()) {
                              AppBlocs.pinCodeBloc.add(
                                PinCodeCheckLockEvent(
                                  route: Routes.VERIFY_PIN_CODE,
                                  arg: {
                                    'type': 'biometric',
                                    'titleSuccess': 'Cài đặt thành công',
                                    'contentSuccess': 'Bạn có thể sử dụng ' +
                                        (isFaceID ? "Face ID" : "Touch ID") +
                                        ' để đăng nhập App $UNIT_NAME_CAP eSign',
                                    'textButtonSuccess': 'Hoàn thành',
                                    'actionSuccess': () {
                                      AppNavigator.popUntil(Routes.HOME);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    'routeSuccess': Routes.SUCCESS_SCREEN,
                                    'actionVerifySuccess': () {
                                      AppBlocs.localAuthBloc.add(
                                        LocalAuthActiveBiometricEvent(
                                          username: AppBlocs.authenticationBloc
                                              .cachedUsername,
                                          password: AppBlocs.authenticationBloc
                                              .cachedPassword,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }
                          },
                        );
                      }
                      return CustomSwitch(
                        value: true,
                        onChanged: () async {
                          if (await AppBlocs.localAuthBloc.disableBiometric(username: AppBlocs.authenticationBloc.cachedUsername)) {
                            AppNavigator.push(
                              Routes.SUCCESS_SCREEN,
                              arguments: {
                                'titleSuccess':
                                    'Cập nhật tùy chọn đăng nhập thành công',
                                'contentSuccess':
                                    'Bạn đã vô hiệu hóa việc sử dụng ' +
                                        (isFaceID ? "Face ID" : "Touch ID") +
                                        ' để đăng nhập.',
                                'textButtonSuccess': 'Hoàn thành',
                                'actionSuccess': () {
                                  AppNavigator.popUntil(Routes.HOME);
                                },
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.px),
                Padding(
                  padding: EdgeInsets.only(left: 20.px),
                  child: Text(
                    'Trợ giúp'.toUpperCase(),
                    style: AppTextStyle.textStyle.s12().w700().cN5(),
                  ),
                ),
                SizedBox(height: 16.px),
                ButtonHome(
                  icon: AppAssetsLinks.provision_condition,
                  title: 'Điều khoản và điều kiện',
                  onTap: () {
                    AppNavigator.push(Routes.ASSETS_PDF_VIEW,
                        arguments: {'assetsFilePath': TERMS_AND_CONDITIONS});
                  },
                ),
                const Divider(height: 1),
                ButtonHome(
                  icon: AppAssetsLinks.contact,
                  title: 'Liên hệ',
                  onTap: () {
                    AppNavigator.push(Routes.WEB_VIEW,
                        arguments: {'link': CONTACT_LINK, 'title': 'Liên hệ'});
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.px),
                  child: const Divider(height: 1),
                ),
                ButtonHome(
                  icon: AppAssetsLinks.log_out,
                  title: 'Đăng xuất',
                  titleStyle: AppTextStyle.textStyle.s16().w500().cP5(),
                  onTap: () {
                    AppBlocs.authenticationBloc
                        .add(AuthenticationLogOutEvent());
                  },
                ),
                SizedBox(height: 24.px),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
