import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/pin_code_bloc/pin_code_bloc.dart';
import '../../../../configs/languages/localization.dart';
import '../../../../helpers/date_time_helper.dart';
import '../../../../helpers/untils/validator_untils.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../../common_widgets/pin_field/my_pin_field.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/app_themes/app_themes.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({Key? key}) : super();

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
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
        showToast(ToastType.warning, title: "Mã PIN nhập lại không chính xác");
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
        appBar: MyAppBar(StringKey.setPinSmartOtp.tr),
        backgroundColor: ColorsLight.Lv1,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(height: 1.px),
                    SizedBox(
                      height: 16.px,
                    ),
                    SvgPicture.asset(AppAssetsLinks.small_badge),
                    SizedBox(
                      height: 8.px,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.px),
                      child: Text(
                        StringKey.setPinDesc.tr,
                        style: AppTextStyle.textStyle.s12().w600().cN5(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16.px,
                    ),
                    Divider(height: 1.px),
                    SizedBox(
                      height: 16.px,
                    ),
                    Text(
                      StringKey.enterPin.tr,
                      style: AppTextStyle.textStyle.s12().w600().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.px),
                      child: MyPinField(
                        padding: EdgeInsets.symmetric(vertical: 8.px),
                        controller: _pinCrl,
                        pinTheme:
                            AppThemes.pinThemeValid(isError: _isErrorNewPass),
                        onComplete: onCompleteNewPin,
                        onChange: onChangeNewPin,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      StringKey.reEnterPin.tr,
                      style: AppTextStyle.textStyle.s12().w600().cN5(),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.px),
                      child: MyPinField(
                        padding: EdgeInsets.symmetric(vertical: 8.px),
                        focusNode: cfPinFocusNode,
                        enabled: !_isErrorNewPass && _validPinCtl,
                        controller: _cfPinCrl,
                        pinTheme:
                            AppThemes.pinThemeValid(isError: _isErrorCfPass),
                        onComplete: onCompleteCfNewPin,
                        onChange: onChangeCfNewPin,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: ButtonPrimary(
                onTap: () {
                  AppBlocs.pinCodeBloc.add(
                    PinCodeSetPinCodeEvent(
                      newPinCode: _cfPinCrl.text,
                      routeSuccess: Routes.SET_PINCODE_SUCCESS,
                    ),
                  );
                },
                enable: _validCfPin &&
                    !_isErrorNewPass &&
                    !_isErrorCfPass &&
                    _cfPinCrl.text == _pinCrl.text,
                content: StringKey.continueText.tr,
                // enable: _valid && _valid2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
