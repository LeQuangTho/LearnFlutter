import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';

import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/text_fields/text_field_common.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class RefuseSign extends StatefulWidget {
  const RefuseSign({Key? key, required this.documentId}) : super(key: key);
  final String documentId;

  @override
  State<RefuseSign> createState() => _RefuseSignState();
}

class _RefuseSignState extends State<RefuseSign> {
  late TextEditingController _reasonController;
  late FocusNode _reasonFocusNode;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _reasonFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
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
              'Từ chối ký',
              style: AppTextStyle.textStyle.s16().w700().cN5(),
            ),
            SizedBox(
              height: 16.px,
            ),
            TextFieldCommon(
              controller: _reasonController,
              labelText: 'Nhập lý do từ chối ký',
              focusNode: _reasonFocusNode,
              onChanged: (v) {
                if (_reasonController.text.isEmpty) {
                  setState(() {
                    _isValid = false;
                  });
                } else {
                  setState(() {
                    _isValid = true;
                  });
                }
              },
            ),
            SizedBox(height: 24.px),
            Row(
              children: [
                Expanded(
                  child: ButtonPop2(
                    buttonTitle: 'Quay lại',
                    height: 40.px,
                  ),
                ),
                SizedBox(width: 8.px),
                Expanded(
                  child: ButtonPrimary(
                    height: 40.px,
                    enable: _isValid,
                    padding: EdgeInsets.zero,
                    content: 'Từ chối ký',
                    onTap: () {
                      AppBlocs.userRemoteBloc.add(UserRemoteRefuseSignEvent(
                          documentId: widget.documentId,
                          rejectReason: _reasonController.text));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.px),
          ],
        ),
      ),
    );
  }
}
