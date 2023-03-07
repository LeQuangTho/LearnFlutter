import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import 'package:sample_sdk_flutter/src/screens/card_back_validation/card_back_preview_screen.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:uiux_ekyc_flutter_sdk/uiux_ekyc_flutter_sdk.dart';

class CardBackValidationScreen extends StatefulWidget {
  SdkConfig? sdkConfig;
  CardBackValidationScreen({required this.sdkConfig, Key? key})
      : super(key: key);

  @override
  State<CardBackValidationScreen> createState() =>
      _CardBackValidationScreenState();
}

class _CardBackValidationScreenState extends State<CardBackValidationScreen> {
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
    Route route = MaterialPageRoute(
      builder: (context) => PreviewCardBackScreen(
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
        appBar: AppBar(),
        text: "Xác định danh tính",
        iconColor: Colors.white,
      ),
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
