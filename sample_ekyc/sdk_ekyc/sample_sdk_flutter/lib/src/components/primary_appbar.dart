import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/utils/app_colors.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  late Color iconColor;
  late Color textColor;
  late Color backgroundColor;
  late bool centerTitle;
  Function? onPressed;

  String? text;
  PrimaryAppBar(
      {Key? key,
      required this.appBar,
      this.text,
      this.iconColor = Colors.black,
      this.textColor = kPrimaryTextColor,
      this.backgroundColor = kPrimaryColor,
      this.onPressed,
      this.centerTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor:
      //   Theme.of(context).appBarTheme.backgroundColor, // Status bar
      // ),
      elevation: 0,
      title: text != null
          ? Text(
        text!,
        // style: AppTextStyle.textStyle.s16().cN5().w700(),
      )
          : Container(),
      leading: GestureDetector(
        onTap: onPressed == null
            ? () => Navigator.pop(context)
            : () => onPressed!(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorsGray.Lv2),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: ColorsNeutral.Lv1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

