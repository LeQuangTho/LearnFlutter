import 'package:flutter/material.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../navigations/app_pages.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/text_fields/text_field_common.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({Key? key}) : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  late TextEditingController _addressController;
  late FocusNode _addressFocusNode;
  String? errorText = '';

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
        text: AppBlocs.userRemoteBloc.userResponseDataEntry.address ?? '');
    _addressFocusNode = FocusNode();
    _addressFocusNode.requestFocus();
    if (_addressController.text.isNotEmpty) {
      validate(_addressController.text);
    }
  }

  void validate(v) {
    if (v.isEmpty ?? true) {
      setState(() {
        errorText = 'Địa chỉ hiện tại không được để trống';
      });
    } else {
      setState(() {
        errorText = null;
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
                'Sửa địa chỉ',
                style: AppTextStyle.textStyle.s16().w700().cN5(),
              ),
              SizedBox(
                height: 8.px,
              ),
              Text(
                'Nhập địa chỉ bạn muốn thay đổi vào ô bên dưới.',
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle.s12().w400().cN4(),
              ),
              SizedBox(
                height: 16.px,
              ),
              TextFieldCommon(
                isError: errorText != null,
                controller: _addressController,
                labelText: 'Địa chỉ',
                focusNode: _addressFocusNode,
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
                      enable: errorText == null,
                      height: 40.px,
                      padding: EdgeInsets.zero,
                      content: 'Lưu',
                      onTap: () {
                        AppBlocs.userRemoteBloc.add(
                          UserRemoteUpdateProfileEvent(
                            userInfo: AppBlocs
                                .userRemoteBloc.userResponseDataEntry
                                .copyWith(
                              address: _addressController.text,
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
