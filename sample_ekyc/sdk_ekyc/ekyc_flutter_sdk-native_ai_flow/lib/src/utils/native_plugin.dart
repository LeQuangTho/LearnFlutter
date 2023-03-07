import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' show Color;
import 'package:camera/camera.dart';
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;

class NativePlugin {
  static const MethodChannel _channel = const MethodChannel('ekyc_flutter_sdk');

  static Future<String?> loadModel(
      {required String model,
      required String modelType,
      String labels = "",
      int numThreads = 1,
      bool isAsset = true}) async {
    print("loadModel");
    return await _channel.invokeMethod(
      'loadModel',
      {
        "model": model,
        "modelType": modelType,
        "labels": labels,
        "numThreads": numThreads,
        "isAsset": isAsset
      },
    );
  }

  static Future<List?> runFaceValidationOnFrame(
      {required CameraImage cameraImage, required SdkConfig sdkConfig}) async {
    var sensorOrientation = sdkConfig.cameraDescription.sensorOrientation;
    return await _channel.invokeMethod(
      'runFaceValidationOnFrame',
      {
        "bytesList": cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        "imageHeight": cameraImage.height,
        "imageWidth": cameraImage.width,
        "screenHeight": sdkConfig.screenSize.height,
        "screenWidth": sdkConfig.screenSize.width,
        "maskLeft": sdkConfig.maskViewSize.left,
        "maskTop": sdkConfig.maskViewSize.top,
        "maskWidth": sdkConfig.maskViewSize.width,
        "maskHeight": sdkConfig.maskViewSize.height,
        "sensorOrientation": sensorOrientation,
        "sizeAspectRatio": sdkConfig.screenSize.aspectRatio
      },
    );
  }

  static Future<List?> runCardValidateOnImage(imglib.Image cardImage) async {
    imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0, filter: 0);
    List<int> byteData = pngEncoder.encodeImage(cardImage);

    return await _channel.invokeMethod(
      'RunCardValidateOnImage',
      {
        "bytesList": byteData,
        "imageHeight": cardImage.height,
        "imageWidth": cardImage.width,
      },
    );
  }
}
