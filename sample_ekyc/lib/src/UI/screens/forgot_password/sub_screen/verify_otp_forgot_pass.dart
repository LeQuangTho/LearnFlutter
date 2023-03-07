import 'package:flutter/material.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/authentication/authentication_bloc.dart';
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

class VerifyOTPForgotPass extends StatefulWidget {
  const VerifyOTPForgotPass({
    Key? key,
    required this.argument,
  }) : super(key: key);
  @override
  State<VerifyOTPForgotPass> createState() => _VerifyOTPForgotPassState();
  final Map<String, dynamic> argument;
}

class _VerifyOTPForgotPassState extends State<VerifyOTPForgotPass> {
  TextEditingController _otpController = TextEditingController();
  bool _isValid = false;

  void onChange(String? _) {
    setState(() {
      if (_otpController.text.length == 6) {
        _isValid = true;
      } else {
        _isValid = false;
      }
    });
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 24.px,
                    ),
                    Text(
                      'Một mã OTP bao gồm 6 chữ số đã được gửi tới SĐT của bạn ${widget.argument['phoneNumber'].toString().replaceAll(RegExp(r'\d(?!\d{0,2}$)'), '*')}.',
                      style: AppTextStyle.textStyle.s16().w400().cN5(),
                    ),
                    SizedBox(
                      height: 16.px,
                    ),
                    Text(
                      'Nhập mã OTP',
                      style: AppTextStyle.textStyle.s12().w600().cN5(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.px),
                      child: MyPinField(
                        padding: EdgeInsets.only(top: 8.px),
                        controller: _otpController,
                        pinTheme: AppThemes.pinThemeNotValid(),
                        onChange: onChange,
                      ),
                    ),
                    TimerIndicator(),
                    SizedBox(
                      height: 24.px,
                    ),
                    ResendOtpButton(onTap: () {
                      AppBlocs.authenticationBloc
                          .add(AuthenticationResendOTPForgotPasswordEvent(
                        phoneNumber: widget.argument['phoneNumber'],
                      ));
                    }),
                  ],
                ),
              ),
              ButtonPrimary(
                onTap: () {
                  AppBlocs.authenticationBloc.add(
                    AuthenticationVerifyOTPForgotPasswordEvent(
                      otp: _otpController.text,
                      phoneNumber: widget.argument['phoneNumber'],
                    ),
                  );
                },
                enable: _isValid,
                content: "Tiếp tục",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
