import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/local_auth/local_auth_bloc.dart';
import '../../../../BLOC/pin_code_bloc/pin_code_bloc.dart';
import '../../../../configs/languages/localization.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/pin_field/my_pin_field.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class OldPinConfirmScreen extends StatefulWidget {
  const OldPinConfirmScreen({Key? key}) : super();

  @override
  State<OldPinConfirmScreen> createState() => _OldPinConfirmScreenState();
}

class _OldPinConfirmScreenState extends State<OldPinConfirmScreen> {
  TextEditingController _pinCrl = TextEditingController();
  bool _validPin = false;
  bool _isError = false;

  void onComplete(String? str) {
    setState(() {
      if (_pinCrl.text.length == 6) {
        _validPin = true;
      } else {
        _validPin = false;
      }
    });
  }

  void onChange(String? str) {
    setState(() {
      if (_pinCrl.text.length != 6) {
        _isError = false;
        _validPin = false;
      } else {
        _validPin = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: MyAppBar('Thay đổi mã PIN'),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Divider(height: 1.px),
                  SizedBox(
                    height: 16.px,
                  ),
                  Text(
                    'Nhập mã PIN đang sử dụng',
                    style: AppTextStyle.textStyle.s16().w400().cN5(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.px,
                  ),
                  Divider(height: 1.px),
                  SizedBox(
                    height: 16.px,
                  ),
                  Text(
                    'Mã PIN đang sử dụng',
                    style: AppTextStyle.textStyle.s12().w600().cN5(),
                    textAlign: TextAlign.center,
                  ),
                  MyPinField(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.px, horizontal: 20.px),
                    controller: _pinCrl,
                    isError: _isError,
                    onChange: onChange,
                    onComplete: onComplete,
                  ),
                  BlocBuilder<PinCodeBloc, PinCodeState>(
                    builder: (context, state) {
                      if (state is PinVerificationFailedState) {
                        return state.countNumberEnterPinCode > 0
                            ? Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.px),
                                child: Text(
                                  'Bạn đã nhập sai mã PIN ${5 - state.countNumberEnterPinCode}/5 lần. Sau 5 lần sai, chức năng sẽ bị khóa',
                                  style:
                                      AppTextStyle.textStyle.s12().w400().cP5(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.px),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: BlocBuilder<LocalAuthBloc, LocalAuthState>(
                builder: (context, state) {
                  return ButtonPrimary(
                    onTap: () {
                      AppBlocs.pinCodeBloc.add(
                        PinCodeVerifyEvent(
                          pinCode: _pinCrl.text,
                          route: Routes.CHANGE_PIN_CODE,
                          arg: {
                            'isFromChangePin': true,
                            'oldPin': _pinCrl.text,
                          },
                        ),
                      );
                      setState(() {
                        _pinCrl.text = "";
                      });
                      if (state is PinVerificationFailedState) {
                        setState(() {
                          _isError = true;
                        });
                      }
                    },
                    enable: _validPin,
                    content: StringKey.continueText.tr,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
