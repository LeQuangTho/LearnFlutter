import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  Color? color;
  Color? backgroundColor;
  late String text;
  Function? onPressed;
  Size? size;
  double? fontSize;
  Icon? icon;
  Color? shadowColor;
  late BorderRadius borderRadius;
  Color? borderColor;

  PrimaryButton(
      {Key? key,
      this.color = Colors.white,
      this.backgroundColor = Colors.blue,
      this.text = "",
      required this.onPressed,
      this.size,
      this.fontSize = 20,
      this.icon,
      this.shadowColor = Colors.black,
      this.borderRadius = const BorderRadius.all(Radius.circular(8)),
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          size == null ? MediaQuery.of(context).size.width * 0.9 : size!.width,
      height: size == null ? 50 : size!.height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // side: borderColor == null
          //     ? null
          //     : BorderSide(
          //         width: 2.0,
          //         color: borderColor!,
          //       ),
          primary: backgroundColor,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        onPressed: onPressed == null
            ? null
            : () {
                onPressed!();
              },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: icon ?? Container(),
              ),
              icon != null ?  const SizedBox(width: 10) : Container(),
              Text(
                text,
                style: TextStyle(fontSize: fontSize ?? 25, color: color),
              ),
            ]),
      ),
    );
  }
}
