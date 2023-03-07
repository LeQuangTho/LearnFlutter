import 'package:flutter/material.dart';

import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../../common_widgets/text_fields/text_field_datetime.dart';

class EditDateOfBirth extends StatefulWidget {
  const EditDateOfBirth({Key? key}) : super(key: key);

  @override
  State<EditDateOfBirth> createState() => _EditDateOfBirthState();
}

class _EditDateOfBirthState extends State<EditDateOfBirth> {
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    _dateOfBirthController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return Dialog(
        backgroundColor: ColorsLight.Lv1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        insetPadding: EdgeInsets.symmetric(horizontal: 36.px),
        child: Container(
          padding: EdgeInsets.fromLTRB(32.px, 24.px, 32.px, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sửa ngày sinh',
                style: AppTextStyle.textStyle.s16().w700().cN5(),
              ),
              SizedBox(
                height: 8.px,
              ),
              Text(
                'Nhập ngày sinh bạn muốn thay đổi vào ô bên dưới.',
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle.s12().w400().cN4(),
              ),
              SizedBox(
                height: 16.px,
              ),
              FieldDatePicker(
                labelText: '',
                controller: _dateOfBirthController,
                hintText: 'dd/MM/yyyy',
              ),
              SizedBox(height: 24.px),
              Row(
                children: [
                  Expanded(
                    child: ButtonPop2(
                      buttonTitle: 'Đóng',
                      height: 40.px,
                    ),
                  ),
                  SizedBox(width: 8.px),
                  Expanded(
                    child: ButtonPrimary(
                      padding: EdgeInsets.zero,
                      height: 40.px,
                      content: 'Lưu',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.px),
            ],
          ),
        ),
      );
    });
  }
}
