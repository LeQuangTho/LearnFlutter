import 'package:flutter/material.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../helpers/untils/validator_untils.dart';
import '../../../../navigations/app_pages.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/text_fields/text_field_common.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({Key? key}) : super(key: key);

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;
  String? errorText = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
        text: AppBlocs.userRemoteBloc.userResponseDataEntry.email ?? '');
    _emailFocusNode = FocusNode();
    _emailFocusNode.requestFocus();
    if (_emailController.text.isNotEmpty) {
      validate(_emailController.text);
    }
  }

  void validate(v) {
    if (ValidatorUtils.isEmail(v)) {
      setState(() {
        errorText = null;
      });
    } else {
      setState(() {
        errorText = 'Email không đúng định dạng';
      });
    }
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
                'Sửa Email',
                style: AppTextStyle.textStyle.s16().w700().cN5(),
              ),
              SizedBox(
                height: 8.px,
              ),
              Text(
                'Nhập Email bạn muốn thay đổi vào ô bên dưới.',
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle.s12().w400().cN4(),
              ),
              SizedBox(
                height: 16.px,
              ),
              TextFieldCommon(
                controller: _emailController,
                labelText: 'Nhập địa chỉ Email',
                focusNode: _emailFocusNode,
                isError: errorText?.isNotEmpty ?? false,
                onChanged: validate,
              ),
              if (errorText?.isNotEmpty ?? false)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    errorText!,
                    style: AppTextStyle.textStyle.s10().w400().cR5(),
                  ),
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
                      height: 40.px,
                      padding: EdgeInsets.zero,
                      content: 'Lưu',
                      enable: errorText == null,
                      onTap: () {
                        AppBlocs.userRemoteBloc.add(
                          UserRemoteUpdateProfileEvent(
                            userInfo: AppBlocs
                                .userRemoteBloc.userResponseDataEntry
                                .copyWith(
                              email: _emailController.text,
                            ),
                          ),
                        );
                        AppNavigator.pop();
                      },
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
