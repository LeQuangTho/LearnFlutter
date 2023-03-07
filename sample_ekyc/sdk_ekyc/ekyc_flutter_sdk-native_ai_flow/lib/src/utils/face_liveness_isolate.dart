import 'dart:isolate';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../ai_service/models/detection.dart';
import '../ai_service/face_liveness.dart';

/// Manages separate Isolate instance for inference
class FaceLivenessIsolate {
  static const String DEBUG_NAME = "InferenceIsolate";

  Isolate? _isolate;
  ReceivePort _receivePort = ReceivePort();
  SendPort? _sendPort;

  SendPort? get sendPort => _sendPort;

  void start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );
    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    await for (final FaceLivenessIsolateData isolateData in port) {
      if (isolateData.detections.length == 0) {
        var _result;
        isolateData.responsePort!.send([2, _result, isolateData.image]);
      } else {
        isolateData.detections.forEach((detection) {
          // load model
          FaceLiveness faceLiveness = FaceLiveness(
              interpreter:
                  Interpreter.fromAddress(isolateData.interpreterAddress));

          // run interpreter
          var _result = faceLiveness.predict(isolateData.image);

          // send
          isolateData.responsePort!.send([2, _result, isolateData.image]);
        });
      }
    }
  }
}

/// Bundles data to pass between Isolate
class FaceLivenessIsolateData {
  imglib.Image image;
  int interpreterAddress;
  SendPort? responsePort;
  List<Detection> detections;

  FaceLivenessIsolateData(
    this.detections,
    this.image,
    this.interpreterAddress,
  );
}
