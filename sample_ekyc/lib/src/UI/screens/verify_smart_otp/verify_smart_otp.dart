import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/timer_indicator/timer_indicator.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../../BLOC/notification/notification_bloc.dart';
import '../../../BLOC/timer/timer_bloc.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../common_widgets/pin_field/my_pin_field.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/app_themes/app_themes.dart';
import '../../designs/layouts/appbar_common.dart';

class VerifySmartOtp extends StatefulWidget {
  const VerifySmartOtp({
    Key? key,
    required this.arguments,
  }) : super(key: key);
  @override
  State<VerifySmartOtp> createState() => _VerifySmartOtpState();
  final Map<String, dynamic> arguments;
}

class _VerifySmartOtpState extends State<VerifySmartOtp> {
  final TextEditingController _smartOtpCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppBlocs.authenticationBloc.add(AuthenticationGetSmartOtpEvent());
  }

  @override
  void dispose() {
    super.dispose();
    AppBlocs.timerBloc.add(StopCountdownSmartOtpTimerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorsWhite.Lv1,
        appBar: MyAppBar('Xác thực Smart OTP'),
        body: Container(
          color: ColorsWhite.Lv1,
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              SizedBox(height: 16.px),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Smart OTP',
                  style: AppTextStyle.textStyle.s16().w400().cN5(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.px),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.px),
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoaded) {
                        _smartOtpCtl.text = state.smartOTP.otp!;
                        return MyPinField(
                          controller: _smartOtpCtl,
                          readOnly: true,
                          obscureText: false,
                          showCursor: false,
                          blinkWhenObscuring: false,
                          pinTheme: AppThemes.pinThemeNotValid(readOnly: true),
                        );
                      } else {
                        return MyPinField(
                          controller: _smartOtpCtl,
                          readOnly: true,
                          obscureText: false,
                          showCursor: false,
                          blinkWhenObscuring: false,
                          pinTheme: AppThemes.pinThemeNotValid(readOnly: true),
                        );
                      }
                    },
                  ),
                ),
              ),
              TimerIndicator(),
              SizedBox(height: 24.px),
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoaded) {
                    return ButtonPrimary(
                      onTap: () {
                        AppBlocs.authenticationBloc.add(
                          AuthenticationVerifySmartOtpEvent(
                            smartOtp: _smartOtpCtl.text,
                            routeSuccess: widget.arguments['routeSuccess'],
                            routeFail: widget.arguments['routeFail'],
                            arg: widget.arguments,
                            action: widget.arguments['actionVerifySuccess'],
                          ),
                        );
                      },
                      content: "Xác thực",
                    );
                  }
                  return ButtonPrimary(
                    enable: false,
                    onTap: () {},
                    content: "Xác thực",
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
