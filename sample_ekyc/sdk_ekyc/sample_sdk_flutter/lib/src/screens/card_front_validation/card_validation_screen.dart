import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/screens/card_front_validation/card_preview_screen.dart';
import 'package:uiux_ekyc_flutter_sdk/uiux_ekyc_flutter_sdk.dart';


class CardValidationScreen extends StatefulWidget {
  const CardValidationScreen({Key? key}) : super(key: key);

  @override
  State<CardValidationScreen> createState() => _CardValidationScreenState();
}

class _CardValidationScreenState extends State<CardValidationScreen> {
  String message = "";
  bool recogResult = true;

  Future<void> cardValidationCallback(
      bool cardValidationResult,
      String rawCardImagePath,
      String cardImagePath,
      String message,
      Future<void> Function() backCardRecogScreenCallback) async {
    if (cardValidationResult) {
      if (AppConfig().sdkCallback != null) {
        AppConfig()
            .sdkCallback!
            .frontCardDeviceCheck(cardValidationResult, "", "", cardImagePath);
      }
    } else {
      if (AppConfig().sdkCallback != null) {
        AppConfig().sdkCallback!.frontCardDeviceCheck(
            cardValidationResult, "error", message, cardImagePath);
      }
    }
    Route route = MaterialPageRoute(
      builder: (context) => PreviewCardScreen(
          cardValidationResult: cardValidationResult,
          message: message,
          backCardRecogScreenCallback: backCardRecogScreenCallback,
          imagePath: cardImagePath,
          rawImagePath: rawCardImagePath),
    );
    Navigator.push(context, route)
        .then((value) => backCardRecogScreenCallback());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
          appBar: AppBar(),
          iconColor: Colors.white,
          text: "Xác định danh tính"),
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CardValidationView(
                currentStep: CardValidationStep.CARDFRONT,
                callback: cardValidationCallback),
          ],
        ),
      ),
    );
  }
}
