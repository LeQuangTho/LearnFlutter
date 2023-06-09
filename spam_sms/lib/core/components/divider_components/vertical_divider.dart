import 'package:flutter/material.dart';
import 'package:spam_sms/core/theme/gen/colors.gen.dart';

class VerticalDividerCustom extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? indent;
  final double? endIndent;

  const VerticalDividerCustom({
    Key? key,
    this.color,
    this.height,
    this.indent,
    this.endIndent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 1,
      color: color ?? AppColor.primary75,
      thickness: height ?? 1,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
