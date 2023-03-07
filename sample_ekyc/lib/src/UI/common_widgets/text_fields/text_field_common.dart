import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';

class TextFieldCommon extends StatefulWidget {
  TextFieldCommon({
    Key? key,
    this.errorText,
    required this.labelText,
    this.hinText,
    this.validatorForm,
    this.textStyle,
    this.helperText,
    this.labelStyle,
    this.suffixIcon,
    this.icon,
    this.controller,
    this.enabled = true,
    this.onChanged,
    this.enableBorderColor,
    this.onTap,
    this.onEditingComplete,
    this.obscureText,
    this.inputBorder = InputBorder.none,
    this.textInputType,
    this.textInputAction,
    this.autoFocus = false,
    this.focusNode,
    this.readOnly = false,
    this.maxLines = 1,
    this.inputFormatter = const [],
    this.isError = false,
  }) : super(key: key);
  final String? errorText;
  final String? labelText;
  final String? hinText;
  final String? Function(String?)? validatorForm;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? icon;
  final TextEditingController? controller;
  final bool? enabled;
  final String? helperText;
  final Function(String)? onChanged;
  final Color? enableBorderColor;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final InputBorder? inputBorder;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final FocusNode? focusNode;
  final bool readOnly;
  final int maxLines;
  final List<TextInputFormatter> inputFormatter;
  final bool isError;

  @override
  State<TextFieldCommon> createState() => _TextFieldCommonState();
}

class _TextFieldCommonState extends State<TextFieldCommon> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.px,
      decoration: BoxDecoration(
        color: widget.isError ? ColorsWarn.Lv5 : null,
        border: widget.isError
            ? Border.all(color: ColorsWarn.Lv2)
            : Border.all(
                width: widget.focusNode?.hasFocus == true ? 2.px : 1.px,
                color: widget.focusNode?.hasFocus == true
                    ? ColorsSuccess.Lv1
                    : ColorsGray.Lv2,
              ),
        borderRadius: BorderRadius.circular(10.px),
      ),
      child: Center(
        child: TextFormField(
          onEditingComplete: widget.onEditingComplete,
          inputFormatters: widget.inputFormatter,
          maxLines: widget.maxLines,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          cursorWidth: 1,
          cursorColor: ColorsNeutral.Lv1,
          onTap: widget.onTap,
          validator: widget.validatorForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          controller: widget.controller,
          obscureText: widget.obscureText ?? false,
          style: widget.enabled == true
              ? AppTextStyle.textStyle.s16().w400().cN5()
              : AppTextStyle.textStyle.s16().w400().cN4(),
          decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: widget.icon,
            errorText: widget.errorText,
            hintText: widget.hinText,
            helperText: widget.helperText,
            border: InputBorder.none,
            labelText: widget.labelText,
            floatingLabelStyle: widget.isError
                ? AppTextStyle.textStyle.s12().w600().cWarn1()
                : AppTextStyle.textStyle.s12().w600().copyWith(
                    color: widget.focusNode?.hasFocus == true
                        ? ColorsSuccess.Lv1
                        : ColorsNeutral.Lv4),
            labelStyle: AppTextStyle.textStyle.s16().w500().cN4(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
            hintStyle: AppTextStyle.textStyle.s16().w400().cN4(),
            errorStyle: AppTextStyle.textStyle,
          ),
        ),
      ),
    );
  }
}
