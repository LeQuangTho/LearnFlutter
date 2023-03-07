import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/components/loading_dialog.dart';
import 'package:sample_sdk_flutter/src/components/time_out_dialog.dart';
import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/components/custom_text_style.dart';
import 'package:sample_sdk_flutter/src/components/primary_button.dart';
import 'package:sample_sdk_flutter/src/screens/face_validation/face_validation_guide.dart';
import 'dart:io';
import 'package:sample_sdk_flutter/src/utils/api_utils/api_helper.dart';
import 'package:sample_sdk_flutter/src/screens/card_back_validation/card_back_validation_screen.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/utils/server_error_code_handler.dart';

void showCardPreviewDialog(
    BuildContext context, Future<void> Function() backCardRecogScreenCallback,
    {String? imagePath, String? rawImagePath}) {
  var size = MediaQuery.of(context).size;
  List<double> cardBoudingBox = computeCardBoudingBox(size);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            margin: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.15,
                20,
                MediaQuery.of(context).size.height * 0.15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F8ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Image.asset('assets/images/danger.png',
                              package: 'sample_sdk_flutter', width: 30),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Thẻ hợp lệ",
                              textAlign: TextAlign.center,
                              style: getCustomTextStyle(
                                fontSize: 15,
                                color: kPrimaryGreen,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imagePath == null
                        ? Image.network('https://picsum.photos/250?image=9')
                        : Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: Text(
                      "Chắc chắn rằng ảnh sau khi chụp không bị mờ\n hoặc bị che khuất",
                      style: getCustomTextStyle(
                        fontSize: 15,
                        color: kPrimaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PrimaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: "Chụp lại",
                          color: kPrimaryTextColor,
                          backgroundColor: kPrimaryWhiteColor,
                          size: Size(size.width * 0.37, 40),
                          borderColor: kPrimaryColor,
                          fontSize: 15,
                        ),
                        const SizedBox(width: 5),
                        PrimaryButton(
                          onPressed: rawImagePath == null
                              ? null
                              : () async {
                                  showLoadingDialog(context);
                                  var response =
                                      await ApiHelper.uploadCardFront(
                                          rawImagePath);
                                  if (response.output != null &&
                                      response.code == "SUCCESS") {
                                    if (response.output!.cardType! ==
                                        'PP_FRONT') {
                                      // check passport
                                      if (AppConfig().sdkCallback != null) {
                                        AppConfig()
                                            .sdkCallback!
                                            .frontCardCloudCheck(true, "", "");
                                      }
                                      Route route = MaterialPageRoute(
                                        builder: (context) => FaceValidateGuide(
                                          sdkConfig: null,
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.push(context, route);
                                    } else {
                                      if (AppConfig().sdkCallback != null) {
                                        AppConfig()
                                            .sdkCallback!
                                            .frontCardCloudCheck(true, "", "");
                                      }
                                      Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            CardBackValidationScreen(
                                          sdkConfig: null,
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.push(context, route);
                                    }
                                  } else {
                                    if (response.error != null) {
                                      if (AppConfig().sdkCallback != null) {
                                        AppConfig()
                                            .sdkCallback!
                                            .frontCardCloudCheck(
                                              false,
                                              response.error!,
                                              getMessageFromErrorCode(
                                                  response.code),
                                            );
                                      }
                                    }
                                    if (response.code == "TIMEOUT") {
                                      Navigator.pop(context);
                                      showTimeOutDialog(context,
                                          message: getMessageFromErrorCode(
                                              response.code));
                                    } else {
                                      Navigator.pop(context);
                                      showFailedCardPreviewDialog(
                                          context, backCardRecogScreenCallback,
                                          imagePath: imagePath,
                                          message: getMessageFromErrorCode(
                                              response.code));
                                    }
                                  }
                                },
                          text: "Xác nhận",
                          color: Colors.white,
                          backgroundColor: kPrimaryColor, //kPrimaryColor,
                          size: Size(size.width * 0.37, 40),
                          fontSize: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    Navigator.pop(context);
  });
}

String splitString(String message) {
  if (message.length < 30) return message;
  int replaceAt = message.length;
  for (int i = 27; i < message.length; i++) {
    if (message[i] == ' ') {
      replaceAt = i;
      break;
    }
  }
  message = message.replaceRange(replaceAt, replaceAt + 1, "\n");
  return message;
}

void showFailedCardPreviewDialog(
    BuildContext context, Future<void> Function() backCardRecogScreenCallback,
    {String? imagePath, String? message}) {
  message ??= "Ảnh không hợp lệ";
  var size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            margin: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.15,
                20,
                MediaQuery.of(context).size.height * 0.15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/warning_icon.png',
                            package: 'sample_sdk_flutter', width: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: message!.length < 30
                              ? Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: getCustomTextStyle(
                                    fontSize: 15,
                                    color: kPrimaryOrange,
                                  ),
                                )
                              : FittedBox(
                                  child: Text(
                                    splitString(message),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryOrange,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imagePath == null
                        ? Image.network('https://picsum.photos/250?image=9')
                        : Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: Text(
                      "Chắc chắn rằng ảnh sau khi chụp không bị mờ\n hoặc bị che khuất",
                      style: getCustomTextStyle(
                        fontSize: 15,
                        color: kPrimaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: 0.45,
                    child: PrimaryButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Chụp lại",
                      color: Colors.white,
                      backgroundColor: kPrimaryColor, //kPrimaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    Navigator.pop(context);
  });
}

List<double> computeCardBoudingBox(var rect) {
  const _CARD_ASPECT_RATIO = 1 / 1.5;
  const _OFFSET_X_FACTOR = 0.05;
  final offsetX = rect.width * _OFFSET_X_FACTOR;
  final cardWidth = rect.width - offsetX * 2;
  final cardHeight = cardWidth * _CARD_ASPECT_RATIO;
  final offsetY = (rect.height - cardHeight) / 2;
  return [offsetX, offsetY, cardWidth, cardHeight];
}
