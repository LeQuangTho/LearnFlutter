import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:sample_sdk_flutter/src/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/constants.dart';

class CardValidationWelcome extends StatelessWidget {
  const CardValidationWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(appBar: AppBar()),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Verify your identity",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTextColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Scan your card",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryTextColor, fontSize: 17),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "(Front Card, Back Card)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // color: getColorFromHex("#2D88FF"),
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/gif/card_guide.gif",
                      package: 'sample_sdk_flutter',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryButton(
              onPressed: () {},
              text: "Got it",
            ),
          )
        ]),
      ),
    );
  }
}
