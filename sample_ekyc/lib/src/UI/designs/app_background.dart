import 'package:flutter/material.dart';

class BackgroundStack extends StatelessWidget {
  const BackgroundStack({
    Key? key,
    required this.child,
    this.backGround,
  }) : super(key: key);
  final Widget child;
  final String? backGround;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Image.asset(
          //   backGround ?? AppAssetsLinks.BACKGROUND,
          //   width: double.infinity,
          //   fit: BoxFit.fill,
          // ),
          Container(
            child: child,
          )
        ],
      ),
    );
  }
}
