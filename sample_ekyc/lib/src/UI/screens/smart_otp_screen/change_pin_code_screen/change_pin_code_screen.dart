import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/helpers/untils/validator_untils.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/pin_code_bloc/pin_code_bloc.dart';
import '../../../../configs/languages/localization.dart';
import '../../../../helpers/date_time_helper.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../../common_widgets/pin_field/my_pin_field.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/app_themes/app_themes.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class ChangePinCodeScreen extends StatefulWidget {
  const ChangePinCodeScreen({Key? key, required this.arg}) : super();
  final Map<String, dynamic>? arg;

  @override
  State<ChangePinCodeScreen> createState() => _ChangePinCodeScreenState();
}

class _ChangePinCodeScreenState extends State<ChangePinCodeScreen> {
  TextEditingController _pinCrl = TextEditingController();
  TextEditingController _cfPinCrl = TextEditingController();
  bool _validPinCtl = false;
  bool _validCfPin = false;
  FocusNode cfPinFocusNode = FocusNode();
  bool _isErrorCfPass = false;
  bool _isErrorNewPass = false;

  void onChangeNewPin(String? _) {
    setState(() {
      if (_pinCrl.text.length == 6) {
        _validPinCtl = true;
      } else {
        _validPinCtl = false;
      }
    });
  }

  void onChangeCfNewPin(String? _) {
    setState(() {
      if (_cfPinCrl.text.length != 6) {
        _isErrorCfPass = false;
        _validCfPin = false;
      }
    });
  }

  void onCompleteCfNewPin(String? _) {
    setState(() {
      if (_cfPinCrl.text.length == 6 && _cfPinCrl.text == _pinCrl.text) {
        _isErrorCfPass = false;
        _validCfPin = true;
      } else {
        _isErrorCfPass = true;
        _validCfPin = false;
        showToast(ToastType.warning, title: 'Mã PIN nhập lại không chính xác');
      }
    });
  }

  void onCompleteNewPin(String? _) {
    if (_cfPinCrl.text.length == 6) {
      onCompleteCfNewPin(_);
    }
    final String dateOfBirth =
        dateTimeFormat3(AppBlocs.userRemoteBloc.userResponseDataEntry.birthday!)
            .replaceAll('/', '')
            .replaceRange(4, 6, '');

    setState(() {
      if (ValidatorUtils.isRepeatingNumber(_pinCrl.text)) {
        _isErrorNewPass = true;
        showToast(ToastType.warning,
            title: 'Không nên dùng 6 số giống nhau đặt làm mã PIN như 666666');
      } else if (ValidatorUtils.isSequential(_pinCrl.text)) {
        _isErrorNewPass = true;
        showToast(ToastType.warning,
            title: 'Không nên đặt các dãy số liên tiếp như 123456 hoặc 654321');
      } else if (_pinCrl.text == dateOfBirth) {
        _isErrorNewPass = true;
        showToast(ToastType.warning,
            title:
                'Không nên đặt ngày tháng năm sinh làm mã PIN vì chúng rất dễ đoán');
      } else if (widget.arg != null &&
          widget.arg?['isFromChangePin'] &&
          _pinCrl.text == widget.arg?['oldPin']) {
        _isErrorNewPass = true;
        showToast(ToastType.warning,
            title:
                'Bạn đang nhập mã PIN trùng với mã PIN cũ, vui lòng nhập mã PIN mới');
      } else {
        _isErrorNewPass = false;
        cfPinFocusNode.requestFocus();
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(height: 1.px),
                  SizedBox(
                    height: 16.px,
                  ),
                  Text(
                    'Thiết lập mã PIN mới',
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
                    'Mã PIN mới',
                    style: AppTextStyle.textStyle.s12().w600().cN5(),
                    textAlign: TextAlign.center,
                  ),
                  MyPinField(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.px, horizontal: 20.px),
                    controller: _pinCrl,
                    pinTheme: AppThemes.pinThemeValid(isError: _isErrorNewPass),
                    onComplete: onCompleteNewPin,
                    onChange: onChangeNewPin,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Xác thực mã PIN mới',
                    style: AppTextStyle.textStyle.s12().w600().cN5(),
                    textAlign: TextAlign.center,
                  ),
                  MyPinField(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.px, horizontal: 20.px),
                    focusNode: cfPinFocusNode,
                    enabled: !_isErrorNewPass && _validPinCtl,
                    controller: _cfPinCrl,
                    pinTheme: AppThemes.pinThemeValid(isError: _isErrorCfPass),
                    onComplete: onCompleteCfNewPin,
                    onChange: onChangeCfNewPin,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: ButtonPrimary(
                onTap: () {
                  AppBlocs.pinCodeBloc.add(
                    PinCodeSetPinCodeEvent(
                      newPinCode: _cfPinCrl.text,
                      routeSuccess: Routes.CHANGE_PIN_SUCCESS,
                      routeFail: Routes.CHANGE_PIN_FAIL,
                    ),
                  );
                },
                enable: _validCfPin &&
                    !_isErrorNewPass &&
                    !_isErrorCfPass &&
                    _cfPinCrl.text == _pinCrl.text,
                content: StringKey.continueText.tr,
              ),
            )
          ],
        ),
      ),
    );
  }
}
