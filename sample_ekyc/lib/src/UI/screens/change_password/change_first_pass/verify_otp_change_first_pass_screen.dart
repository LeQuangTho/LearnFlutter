import 'package:flutter/material.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/authentication/authentication_bloc.dart';
import '../../../../BLOC/authentication/models/create_password/create_password_form2.dart';
import '../../../../BLOC/timer/resend_otp/resend_otp_bloc.dart';
import '../../../../BLOC/timer/timer_bloc.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/buttons/resend_otp_button.dart';
import '../../../common_widgets/pin_field/my_pin_field.dart';
import '../../../common_widgets/timer_indicator/timer_indicator.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/app_themes/app_themes.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class VerifyOtpChangeFirstPassScreen extends StatefulWidget {
  const VerifyOtpChangeFirstPassScreen({
    Key? key,
    required this.argument,
  }) : super(key: key);
  @override
  State<VerifyOtpChangeFirstPassScreen> createState() =>
      _VerifyOtpChangeFirstPassScreenState();
  final Map<String, dynamic> argument;
}

class _VerifyOtpChangeFirstPassScreenState
    extends State<VerifyOtpChangeFirstPassScreen> {
  TextEditingController _otpController = TextEditingController();
  bool _isOtpValid = false;

  @override
  void dispose() {
    AppBlocs.timerBloc.add(StopCountdownSmsOtpTimerEvent());
    AppBlocs.resendBloc.add(StopedResendOtpEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorsLight.Lv1,
        appBar: MyAppBar('Xác thực OTP'),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 24.px,
                      ),
                      Text(
                        'Một mã OTP bao gồm 6 chữ số đã được gửi tới SĐT của bạn ${widget.argument['userName'].toString().replaceAll(RegExp(r'\d(?!\d{0,2}$)'), '*')}.',
                        style: AppTextStyle.textStyle.s16().w400().cN5(),
                      ),
                      SizedBox(
                        height: 16.px,
                      ),
                      Text(
                        'Nhập mã OTP',
                        style: AppTextStyle.textStyle.s12().w600().cN5(),
                      ),
                      MyPinField(
                        obscureText: false,
                        padding: EdgeInsets.only(top: 16.px, bottom: 8.px),
                        controller: _otpController,
                        pinTheme: AppThemes.pinThemeNotValid(),
                        onChange: (v) {
                          setState(() {
                            if (_otpController.text.length == 6) {
                              _isOtpValid = true;
                            } else {
                              _isOtpValid = false;
                            }
                          });
                        },
                      ),
                      TimerIndicator(),
                      SizedBox(
                        height: 24.px,
                      ),
                      ResendOtpButton(onTap: () {
                        if ((widget.argument['isNewDevice'] as bool)) {
                          AppBlocs.authenticationBloc.add(
                            AuthenticationResendOTPEvent(),
                          );
                        } else {
                          AppBlocs.authenticationBloc.add(
                            AuthenticationResendOTPChangeFirstPassEvent(),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  if ((widget.argument['isNewDevice'] as bool)) {
                    AppBlocs.authenticationBloc.add(
                      AuthenticationActiveDeviceEvent(
                        userName: widget.argument['userName'],
                        otp: _otpController.text,
                      ),
                    );
                  } else {
                    AppBlocs.authenticationBloc.add(
                      AuthenticationChangeFirstPasswordEvent(
                        userId: widget.argument['userId'],
                        userName: widget.argument['userName'],
                        isNewDevice: (widget.argument['isNewDevice'] as bool),
                        createPasswordForm: CreatePasswordForm2(
                          newPassword: widget.argument['newPassword'],
                          oldPassword: widget.argument['oldPassword'],
                          otp: _otpController.text,
                        ),
                      ),
                    );
                  }
                },
                enable: _isOtpValid,
                content: "Tiếp tục",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
