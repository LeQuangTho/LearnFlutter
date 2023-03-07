import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'models/detection.dart';
import 'models/anchor_option.dart';
import 'models/options_face.dart';
import '../utils/util_face.dart';
import 'dart:io';
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';
import 'package:flutter/services.dart';

class Detector {
  Interpreter? _interpreter;
  NormalizeOp _normalizeInput = NormalizeOp(127.5, 127.5);
  ImageProcessor? _imageProcessor;

  static OptionsFace optionsBack = OptionsFace(
      numClasses: 1,
      numBoxes: 896,
      numCoords: 16,
      keypointCoordOffset: 4,
      ignoreClasses: [],
      scoreClippingThresh: 100.0,
      minScoreThresh: 0.8,
      numKeypoints: 6,
      numValuesPerKeypoint: 2,
      reverseOutputOrder: true,
      boxCoordOffset: 0,
      xScale: 256,
      yScale: 256,
      hScale: 256,
      wScale: 256);

  static AnchorOption anchorsBack = AnchorOption(
      inputSizeHeight: 256,
      inputSizeWidth: 256,
      minScale: 0.1484375,
      maxScale: 0.75,
      anchorOffsetX: 0.5,
      anchorOffsetY: 0.5,
      numLayers: 4,
      featureMapHeight: [],
      featureMapWidth: [],
      strides: [16, 32, 32, 32],
      aspectRatios: [1.0],
      reduceBoxesInLowestLayer: false,
      interpolatedScaleAspectRatio: 1.0,
      fixedAnchorSize: true);

  static OptionsFace optionsFront = OptionsFace(
      numClasses: 1,
      numBoxes: 896,
      numCoords: 16,
      keypointCoordOffset: 4,
      ignoreClasses: [],
      scoreClippingThresh: 100.0,
      minScoreThresh: 0.7,
      numKeypoints: 6,
      numValuesPerKeypoint: 2,
      reverseOutputOrder: true,
      boxCoordOffset: 0,
      xScale: 128,
      yScale: 128,
      hScale: 128,
      wScale: 128);

  static AnchorOption anchorsFront = AnchorOption(
      inputSizeHeight: 128,
      inputSizeWidth: 128,
      minScale: 0.1484375,
      maxScale: 0.75,
      anchorOffsetX: 0.5,
      anchorOffsetY: 0.5,
      numLayers: 4,
      featureMapHeight: [],
      featureMapWidth: [],
      strides: [8, 16, 16, 16],
      aspectRatios: [1.0],
      reduceBoxesInLowestLayer: false,
      interpolatedScaleAspectRatio: 1.0,
      fixedAnchorSize: true);
  List<Anchor>? _anchors;

  Detector({Interpreter? interpreter}) {
    loadModel(interpreter: interpreter);
  }

  /// Get byte buffer
  Future<Uint8List> _getModelBuffer(String filePath) async {
    ByteData rawAssetFile = await rootBundle.load(filePath);
    final rawBytes = rawAssetFile.buffer.asUint8List();
    return rawBytes;
  }

  Future<Interpreter> getModelFromAsset(String assetName,
      {InterpreterOptions? options}) async {
    Uint8List buffer = await _getModelBuffer(assetName);
    return Interpreter.fromBuffer(buffer, options: options);
  }

  void loadModel({Interpreter? interpreter}) async {
    if (interpreter == null) {
      try {
        if (Platform.isAndroid) {
          _interpreter = await getModelFromAsset(
              'packages/ekyc_flutter_sdk/assets/models/face_detection_front.tflite');
        } else {
          // load interpreter for cpu
          _interpreter = await getModelFromAsset(
              'packages/ekyc_flutter_sdk/assets/models/face_detection_front.tflite');
        }
      } catch (e) {
        print("Error while creating interpreter: $e");
      }
    } else {
      _interpreter = interpreter;
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage, List<int> _inputShape) {
    if (_imageProcessor == null) {
      _imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(
              _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
          .add(_normalizeInput)
          .build();
    }
    inputImage = _imageProcessor!.process(inputImage);
    return inputImage;
  }

  List<Detection>? predict(imglib.Image image) {
    /// setting support object
    if (_interpreter == null) {
      print("Interpreter not initialized");
      return null;
    }
    var startPreprocessForDetect = DateTime.now().millisecondsSinceEpoch;
    if (_anchors == null) {
      _anchors = getAnchors(anchorsFront);
    }

    /// setting input
    TensorImage inputImage = TensorImage.fromImage(image);
    inputImage =
        getProcessedImage(inputImage, _interpreter!.getInputTensor(0).shape);

    /// setting output
    TensorBuffer output0 = TensorBuffer.createFixedSize(
        _interpreter!.getOutputTensor(0).shape,
        _interpreter!.getOutputTensor(0).type);
    TensorBuffer output1 = TensorBuffer.createFixedSize(
        _interpreter!.getOutputTensor(1).shape,
        _interpreter!.getOutputTensor(1).type);
    Map<int, ByteBuffer> outputs = {0: output0.buffer, 1: output1.buffer};

    var startDetectTime = DateTime.now().millisecondsSinceEpoch;

    /// run predict
    _interpreter!.runForMultipleInputs([inputImage.buffer], outputs);
    var endDetectTime = DateTime.now().millisecondsSinceEpoch;

    /// post process
    List<double> regression = output0.getDoubleList();
    List<double> classificators = output1.getDoubleList();
    List<Detection> detections =
        process(optionsFront, classificators, regression, _anchors!);

    List<Detection> _detections =
        origNms(detections, 0.3, image.width, image.height);

    int flag = -1;

    for (int i = 0; i < _detections.length; i++) {
      int x = (_detections[i].xMin * 100).round();
      int y = (_detections[i].yMin * 100).round();
      int h = (_detections[i].height * 100).round();
      int w = (_detections[i].width * 100).round();
      if (x == 89 && y == 2 && w == 9 && h == 9) {
        flag = i;
      }
      // print("x = $x y = $y w = $w h = $h ");
    }
    if (flag != -1) {
      _detections.removeAt(flag);
    }

    return _detections;
  }

  Interpreter? get interpreter => _interpreter;
}
