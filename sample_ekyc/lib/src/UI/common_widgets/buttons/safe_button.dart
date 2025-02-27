import 'package:flutter/material.dart';

class SafeButton extends StatefulWidget {
  SafeButton({
    Key? key,
    required this.child,
    required this.onSafeTap,
    this.intervalMs = 500,
  }) : super(key: key);
  final Widget child;
  final GestureTapCallback onSafeTap;
  final int intervalMs;

  @override
  _SafeButtonState createState() => _SafeButtonState();
}

class _SafeButtonState extends State<SafeButton> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastTimeClicked > widget.intervalMs) {
          lastTimeClicked = now;
          widget.onSafeTap();
        }
      },
      child: widget.child,
    );
  }
}
