import 'package:flutter/material.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';

class CheckBoxCustom extends StatefulWidget {
  final String? title;
  final bool isChecked;
  final Function(bool value) onPress;

  const CheckBoxCustom({
    Key? key,
    this.title,
    required this.onPress,
    required this.isChecked,
  }) : super(key: key);

  @override
  CheckBoxCustomState createState() => CheckBoxCustomState();
}

class CheckBoxCustomState extends State<CheckBoxCustom> {
  bool _isCheck = false;
  @override
  void initState() {
    super.initState();
    _isCheck = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            setState(() {
              _isCheck = !_isCheck;
              widget.onPress(widget.isChecked);
            });
          },
          icon: Container(
            decoration: BoxDecoration(
                color: _isCheck ? ColorsSuccess.Lv1 : Colors.white,
                border: Border.all(color: ColorsGray.Lv1),
                borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.check, size: 18, color: Colors.white),
          ),
        ),
        SizedBox(width: 8),
        Text(
          widget.title ?? '',
          style: AppTextStyle.textStyle.s16().w400().cN3(),
        ),
      ],
    );
  }
}
