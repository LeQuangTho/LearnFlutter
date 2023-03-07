import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/pin_code_bloc/pin_code_bloc.dart';
import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../common_widgets/pin_field/my_pin_field.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/app_themes/app_themes.dart';
import '../../designs/layouts/appbar_common.dart';

class VerifyPinCode extends StatefulWidget {
  const VerifyPinCode({Key? key, required this.arguments}) : super(key: key);
  final Map<String, dynamic> arguments;
  @override
  State<VerifyPinCode> createState() => _VerifyPinCodeState();
}

class _VerifyPinCodeState extends State<VerifyPinCode> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  void onComplete(String? str) async {
    switch (widget.arguments['type']) {
      case 'biometric':
        AppBlocs.pinCodeBloc.add(
          PinCodeVerifyEvent(
            pinCode: _pinController.text,
            route: Routes.VERIFY_SMART_OTP,
            arg: widget.arguments,
          ),
        );
        break;
      case 'eKYC_di_cer':
        AppBlocs.pinCodeBloc.add(
          PinCodeVerifyEvent(
            pinCode: _pinController.text,
            route: Routes.VERIFY_SMART_OTP,
            arg: widget.arguments,
          ),
        );
        break;
      default:
    }

    _pinController.text = "";
    _pinFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      appBar: MyAppBar('Xác thực Smart OTP'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 24.px,
                  ),
                  Text(
                    'Nhập mã pin',
                    style: AppTextStyle.textStyle.s16().w500().cN5(),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MyPinField(
                    showCursor: false,
                    onComplete: onComplete,
                    controller: _pinController,
                    focusNode: _pinFocusNode,
                    padding: EdgeInsets.symmetric(horizontal: 90.px),
                    textStyle: TextStyle(color: Colors.transparent),
                    pinTheme: AppThemes.dotPinTheme(controller: _pinController),
                  ),
                  BlocBuilder<PinCodeBloc, PinCodeState>(
                    builder: (context, state) {
                      if (state is PinVerificationFailedState) {
                        return state.countNumberEnterPinCode > 0
                            ? Text(
                                'Bạn đã nhập sai mã PIN ${5 - state.countNumberEnterPinCode}/5 lần. Sau 5 lần sai, chức năng sẽ bị khóa',
                                style:
                                    AppTextStyle.textStyle.s12().w400().cP5(),
                                textAlign: TextAlign.center,
                              )
                            : Flexible(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        'Chức năng này bị tạm khóa, vui lòng nhấn ',
                                    style: AppTextStyle.textStyle
                                        .s12()
                                        .w400()
                                        .cP5(),
                                    children: [
                                      WidgetSpan(
                                        child: InkWell(
                                          onTap: () {
                                            AppNavigator.push(
                                                Routes.FORGOT_PIN_CODE);
                                          },
                                          child: Text(
                                            'Quên mã PIN ',
                                            style: AppTextStyle.textStyle
                                                .s12()
                                                .w700()
                                                .cP5(),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'để thực hiện cài đặt lại mã PIN.',
                                        style: AppTextStyle.textStyle
                                            .s12()
                                            .w400()
                                            .cP5(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<PinCodeBloc, PinCodeState>(
              builder: (context, state) {
                if (state is PinVerificationFailedState) {
                  return TextButton(
                    onPressed: () {
                      AppNavigator.push(Routes.FORGOT_PIN_CODE);
                    },
                    child: Text(
                      'Quên mã PIN?',
                      style: AppTextStyle.textStyle.s16().w700().cN5(),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(
              height: 16.px,
            ),
          ],
        ),
      ),
    );
  }
}
