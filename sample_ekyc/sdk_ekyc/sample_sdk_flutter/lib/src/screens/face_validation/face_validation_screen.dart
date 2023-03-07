import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/screens/face_validation/face_validation_preview_screen.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/utils/native_service.dart';
import 'package:uiux_ekyc_flutter_sdk/uiux_ekyc_flutter_sdk.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FaceValidationScreen extends StatefulWidget {
  const FaceValidationScreen({Key? key}) : super(key: key);

  @override
  State<FaceValidationScreen> createState() => _FaceValidationScreenState();
}

class _FaceValidationScreenState extends State<FaceValidationScreen> {
  Future<void> faceValidationCallback(
      bool faceValidationResult,
      String videoPath,
      String errorCode,
      String message,
      Future<void> Function() backFaceRecogScreenCallback) async {
    if (faceValidationResult) {
      var arr = videoPath.split("/");
      var fileName = arr[arr.length - 1];
      var newfile = File(videoPath);

      final appDir = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();

      final appPath = appDir!.path;
      final fileOnDevice = File('$appPath/${fileName}'); //FOR ANDROID AND IOS
      await fileOnDevice.writeAsBytes(newfile.readAsBytesSync());
      if (AppConfig().sdkCallback != null) {
        AppConfig()
            .sdkCallback!
            .faceDeviceCheck(faceValidationResult, "", "", videoPath);
      }
      Route route = MaterialPageRoute(
        builder: (context) => FaceValidationPreview(filePath: videoPath),
      );
      Navigator.push(context, route)
          .then((value) => backFaceRecogScreenCallback());
    } else {
      if (AppConfig().sdkCallback != null) {
        AppConfig()
            .sdkCallback!
            .faceDeviceCheck(faceValidationResult, errorCode, message, "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
          appBar: AppBar(),
          iconColor: Colors.white,
          text: "Quay video khuôn mặt"),
      body: Container(
        child: Stack(fit: StackFit.expand, children: <Widget>[
          FaceValidationView(faceValidationCallback: faceValidationCallback),
        ]),
      ),
    );
  }
}
