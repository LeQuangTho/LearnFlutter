import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/card_validation_view.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardBackkValidationScreen extends StatefulWidget {
  SdkConfig? sdkConfig;
  CardBackkValidationScreen({required this.sdkConfig, Key? key})
      : super(key: key);

  @override
  State<CardBackkValidationScreen> createState() =>
      _CardBackkValidationScreenState();
}

class _CardBackkValidationScreenState extends State<CardBackkValidationScreen> {
  String message = "";
  bool recogResult = true;

  @override
  void initState() {
    super.initState();
    initSdkConfig();
  }

  void initSdkConfig() {
    if (widget.sdkConfig != null && !AppConfig.isInit) {
      AppConfig.isInit = true;
      AppConfig().source = widget.sdkConfig!.source;
      AppConfig().apiUrl = widget.sdkConfig!.apiUrl;
      AppConfig().token = widget.sdkConfig!.token;
      AppConfig().timeOut = widget.sdkConfig!.timeOut;
      AppConfig().email = widget.sdkConfig!.email;
      AppConfig().phone = widget.sdkConfig!.phone;
      AppConfig().backRoute = widget.sdkConfig!.backRoute;
      AppConfig().sdkCallback = widget.sdkConfig!.sdkCallback;
    }
  }

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
            .backCardDeviceCheck(cardValidationResult, "", "", cardImagePath);
      }
    } else {
      if (AppConfig().sdkCallback != null) {
        AppConfig().sdkCallback!.backCardDeviceCheck(
            cardValidationResult, "error", message, cardImagePath);
      }
    }
    // Route route = MaterialPageRoute(
    //   builder: (context) => PreviewCardBackScreen(
    //       cardValidationResult: cardValidationResult,
    //       message: message,
    //       backCardRecogScreenCallback: backCardRecogScreenCallback,
    //       imagePath: cardImagePath,
    //       rawImagePath: rawCardImagePath),
    // );
    // AppNavigator.r(context, route)
    //     .then((value) => backCardRecogScreenCallback());

    await AppNavigator.push(Routes.PREVIEW_CARD_BACK, arguments: {
      'cardValidationResult': cardValidationResult,
      'message': message,
      'backCardRecogScreenCallback': backCardRecogScreenCallback,
      'cardImagePath': cardImagePath,
      'rawCardImagePath': rawCardImagePath,
    });
    backCardRecogScreenCallback();
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
                currentStep: CardValidationStep.CARDBACK,
                callback: cardValidationCallback),
          ],
        ),
      ),
    );
  }
}
