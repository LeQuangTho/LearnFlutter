import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/app_themes/app_themes.dart';
import 'obscursing_widget.dart';

class MyPinField extends StatelessWidget {
  const MyPinField({
    Key? key,
    this.controller,
    this.isError,
    this.onChange,
    this.onComplete,
    this.padding = EdgeInsets.zero,
    this.pinTheme,
    this.textStyle,
    this.showCursor = true,
    this.enabled = true,
    this.blinkWhenObscuring = true,
    this.obscureText = true,
    this.focusNode,
    this.readOnly = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool? isError;
  final Function(String)? onChange;
  final Function(String)? onComplete;
  final EdgeInsets padding;
  final PinTheme? pinTheme;
  final TextStyle? textStyle;
  final bool showCursor;
  final bool enabled;
  final bool blinkWhenObscuring;
  final bool obscureText;
  final FocusNode? focusNode;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: PinCodeTextField(
        readOnly: readOnly,
        focusNode: focusNode,
        enabled: enabled,
        obscuringWidget: showCursor ? ObscursingWidget() : null,
        showCursor: showCursor,
        autoFocus: true,
        obscureText: obscureText,
        blinkWhenObscuring: blinkWhenObscuring,
        controller: controller,
        appContext: context,
        cursorWidth: 1,
        pastedTextStyle: textStyle ?? AppTextStyle.textStyle.s24().w400().cN5(),
        textStyle: textStyle ?? AppTextStyle.textStyle.s24().w400().cN5(),
        length: 6,
        animationType: AnimationType.fade,
        pinTheme:
            pinTheme ?? AppThemes.pinThemeValid(isError: isError ?? false),
        cursorColor: ColorsNeutral.Lv1,
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        onCompleted: onComplete,
        onChanged: onChange ?? (_) {},
        validator: (v) {
          return '';
        },
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }
}
