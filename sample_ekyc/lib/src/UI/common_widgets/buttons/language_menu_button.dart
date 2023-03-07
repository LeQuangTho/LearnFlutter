import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:hdsaison_signing/src/configs/languages/localization.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';

class LanguagePickerButton extends StatefulWidget {
  LanguagePickerButton({Key? key}) : super(key: key);

  @override
  State<LanguagePickerButton> createState() => _LanguagePickerButtonState();
}

class _LanguagePickerButtonState extends State<LanguagePickerButton> {
  late List<DropdownMenuItem<String>> _dropdownList;
  late String _value;
  @override
  void initState() {
    super.initState();
    _dropdownList = LanguageService.supportLanguage.map((e) {
      return DropdownMenuItem<String>(
          value: e.languageCode, child: Text(e.languageCode.toUpperCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _value = I18n.of(context).locale.languageCode;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: ColorsGray.Lv2),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(8),
        value: _value,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: ColorsNeutral.Lv1,
        ),
        elevation: 5,
        style: AppTextStyle.textStyle.s16().w400().cN5(),
        dropdownColor: ColorsNeutral.Lv6,
        underline: Container(),
        alignment: Alignment.center,
        onChanged: (String? newLanguageCode) async {
          setState(
            () {
              if (newLanguageCode != null) {
                _value = newLanguageCode;
                LanguageService().changeLanguage(newLanguageCode);
              }
            },
          );
        },
        items: _dropdownList,
      ),
    );
  }
}
