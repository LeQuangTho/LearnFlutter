import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/timer_indicator/timer_indicator.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/notification/notification_bloc.dart';
import '../../../../BLOC/timer/timer_bloc.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/pin_field/my_pin_field.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/app_themes/app_themes.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ConfirmSmartOtpScreen extends StatefulWidget {
  final Map<String, dynamic>? argument;
  const ConfirmSmartOtpScreen({
    Key? key,
    this.argument,
  }) : super(key: key);
  @override
  State<ConfirmSmartOtpScreen> createState() => _ConfirmSmartOtpScreenState();
}

class _ConfirmSmartOtpScreenState extends State<ConfirmSmartOtpScreen> {
  final TextEditingController _smartOtpCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc.add(UserRemoteRequestSigningEvent());

    /// yêu cầu ký đồng thời tự điền HOTP
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
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Smart OTP',
                  style: AppTextStyle.textStyle.s16().w400().cN5(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.px),
                child: Form(
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
                            pinTheme:
                                AppThemes.pinThemeNotValid(readOnly: true),
                          );
                        } else {
                          return MyPinField(
                            controller: _smartOtpCtl,
                            readOnly: true,
                            obscureText: false,
                            showCursor: false,
                            blinkWhenObscuring: false,
                            pinTheme:
                                AppThemes.pinThemeNotValid(readOnly: true),
                          );
                        }
                      },
                    ),
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
                        final params = ModalRoute.of(context)!
                            .settings
                            .arguments as Map<String, dynamic>;

                        AppBlocs.userRemoteBloc
                            .add(UserRemoteConfirmSigningEvent(
                          params['isSignNature'],
                          params['idCts'] ?? '',
                        ));

                        ///xác nhận ký
                      },
                      content: "Tiếp tục",
                    );
                  }
                  return ButtonPrimary(
                    enable: false,
                    onTap: () {},
                    content: "Tiếp tục",
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
