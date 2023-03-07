import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? icon;

  MyAppBar(this.title, {this.icon})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super();

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  final Size preferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  _MyAppBarState();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60.px,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            Theme.of(context).appBarTheme.backgroundColor, // Status bar
      ),
      centerTitle: true,
      elevation: 0,
      title: Text(
        widget.title,
        style: AppTextStyle.textStyle.s16().cN5().w700(),
      ),
      backgroundColor: ColorsLight.Lv1,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: 40.px,
              height: 40.px,
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
      actions: [
        widget.icon ?? const SizedBox(),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
