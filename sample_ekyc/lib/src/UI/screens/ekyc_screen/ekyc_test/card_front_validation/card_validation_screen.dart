import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';

import '../card_validation_view.dart';

class CardFrontValidationScreen extends StatefulWidget {
  const CardFrontValidationScreen({Key? key}) : super(key: key);

  @override
  State<CardFrontValidationScreen> createState() =>
      _CardFrontValidationScreenState();
}

class _CardFrontValidationScreenState extends State<CardFrontValidationScreen> {
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
    // Route route = MaterialPageRoute(
    //   builder: (context) => PreviewCardScreen(
    //       cardValidationResult: cardValidationResult,
    //       message: message,
    //       backCardRecogScreenCallback: backCardRecogScreenCallback,
    //       imagePath: cardImagePath,
    //       rawImagePath: rawCardImagePath),
    // );
    // Navigator.push(context, route)
    //     .then((value) => backCardRecogScreenCallback());

    await AppNavigator.push(Routes.PREVIEW_CARD_FRONT, arguments: {
      'cardValidationResult': cardValidationResult,
      'message': message,
      'backCardRecogScreenCallback': backCardRecogScreenCallback,
      'cardImagePath': cardImagePath,
      'rawCardImagePath': rawCardImagePath,
    });
    backCardRecogScreenCallback();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: MyAppBar("Chụp ảnh CCCD/CMND"),
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
