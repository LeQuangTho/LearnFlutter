import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/extentions/typedef.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final Callback onChanged;

  CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  // Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // _circleAnimation = AlignmentTween(
    //         begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
    //         end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
    //     .animate(CurvedAnimation(
    //         parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // if (_animationController!.isCompleted) {
            //   _animationController!.reverse();
            // } else {
            //   _animationController!.forward();
            // }
            // widget.value == false
            //     ? widget.onChanged(true)
            //     : widget.onChanged(false);
            widget.onChanged();
          },
          child: Container(
            width: 36.px,
            height: 20.px,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.px),
              color: widget.value ? ColorsPrimary.Lv1 : ColorsGray.Lv2,
            ),
            child: Container(
              padding: EdgeInsets.all(2.px),
              alignment:
                  widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16.px,
                height: 16.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.px),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
