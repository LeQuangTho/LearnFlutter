import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../../helpers/date_time_helper.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';

import 'date_formatter.dart';

class FieldDatePicker extends StatefulWidget {
  final String? hintText;
  final DateTime? maxDate;
  final int? maxLength;
  final bool enableFuture;
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
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final FocusNode? focusNode;
  final bool readOnly;
  final int maxLines;
  final bool isError;

  const FieldDatePicker({
    Key? key,
    this.hintText,
    this.maxDate,
    this.onChanged,
    this.maxLength,
    this.enableFuture = true,
    required this.controller,
    this.errorText,
    required this.labelText,
    this.hinText,
    this.validatorForm,
    this.textStyle,
    this.helperText,
    this.labelStyle,
    this.suffixIcon,
    this.icon,
    this.enabled = true,
    this.enableBorderColor,
    this.onTap,
    this.onEditingComplete,
    this.obscureText,
    this.inputBorder = InputBorder.none,
    this.textInputAction,
    this.autoFocus = false,
    this.focusNode,
    this.readOnly = false,
    this.maxLines = 1,
    this.isError = false,
  }) : super(key: key);

  @override
  State<FieldDatePicker> createState() => _FieldDatePickerState();
}

class _FieldDatePickerState extends State<FieldDatePicker> {
  String? errorText;
  late DateTime firstDate;
  late DateTime lastDate;

  DateTime? _parseDate(String? inputString) {
    if (inputString == null) {
      return null;
    }

    final List<String> inputParts = inputString.split('/');
    if (inputParts.length != 3) {
      return null;
    }

    final int? year = int.tryParse(inputParts[2], radix: 10);
    if (year == null || year < 1 || inputParts[2].length != 4) {
      return null;
    }

    final int? month = int.tryParse(inputParts[1], radix: 10);
    if (month == null || month < 1 || month > 12) {
      return null;
    }

    final int? day = int.tryParse(inputParts[0], radix: 10);
    if (day == null || day < 1 || day > _getDaysInMonth(year, month)) {
      return null;
    }
    return DateTime(year, month, day).toLocal();
  }

  int _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) {
        return 29;
      }
      return 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }

  // bool _isValidAcceptableDate(DateTime? date) {
  //   return
  //      date != null && !date.isBefore(firstDate) && !date.isAfter(lastDate);}

  String? validateDate(String? text) {
    final DateTime? date = _parseDate(text);

    if (date == null) {
      errorText = 'Không đúng định dạng ngày';
      // } else if (!_isValidAcceptableDate(date)) {
      //   errorText = 'Không đúng định dạng';
    } else {
      errorText = null;
    }
    setState(() {});
    return errorText;
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
    firstDate = DateTime(1900);
    lastDate = DateTime(2100);
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
            LengthLimitingTextInputFormatter(10),
            DateFormatter(),
          ],
          maxLines: widget.maxLines,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          keyboardType: TextInputType.number,
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
            suffixIcon: InkWell(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  onConfirm: (time) {
                    setState(() {
                      widget.controller?.text =
                          dateTimeFormat3(time.toString());
                    });
                  },
                  theme: DatePickerTheme(
                    backgroundColor: Colors.white,
                  ),
                );
              },
              child: Container(
                height: 48.px,
                width: 48.px,
                child: SvgPicture.asset(
                  AppAssetsLinks.ic_calendar_2,
                  color: ColorsNeutral.Lv1,
                  height: 24.px,
                  width: 24.px,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
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
