import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';
import 'package:flutter/services.dart';

class CardLiveness {
  Interpreter? _interpreter;
  NormalizeOp _normalizeOp = NormalizeOp(127.5, 127.5);
  ImageProcessor? _imageProcessor;

  CardLiveness({Interpreter? interpreter}) {
    _loadModel(interpreter: interpreter);
  }

  CardLiveness.fromAddress(int interpreterAddress) {
    _loadModel(interpreter: Interpreter.fromAddress(interpreterAddress));
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

  void _loadModel({Interpreter? interpreter}) async {
    if (interpreter == null) {
      if (Platform.isAndroid) {
        final gpuDelegateV2 = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
          inferencePriority1: TfLiteGpuInferencePriority.minLatency,
          inferencePriority2: TfLiteGpuInferencePriority.auto,
          inferencePriority3: TfLiteGpuInferencePriority.auto,
        ));
        var interpreterOptions = InterpreterOptions()
          ..addDelegate(gpuDelegateV2);
        try {
          _interpreter = await getModelFromAsset(
              'packages/ekyc_flutter_sdk/assets/models/cardliveness_mymodel_12_mobilenetv2_26classes_finger_spotlight_04042022_1553.tflite',
              options: interpreterOptions);
        } catch (e) {
          print("Error while creating interpreter: $e");
        }
      } else {
        try {
          _interpreter = await getModelFromAsset(
              'packages/ekyc_flutter_sdk/assets/models/cardliveness_mymodel_12_mobilenetv2_26classes_finger_spotlight_04042022_1553.tflite');
        } catch (e) {
          print("Error while creating interpreter: $e");
        }
      }
    } else {
      _interpreter = interpreter;
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage, List<int> _inputShape) {
    if (_imageProcessor == null) {
      double mean = _meanOf(inputImage.getBuffer().asFloat32List());
      double std = _stdOf(inputImage.getBuffer().asFloat32List(), mean);
      _imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(
              _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
          // .add(NormalizeOp(mean, std))
          .build();
    }
    inputImage = _imageProcessor!.process(inputImage);
    return inputImage;
  }

  List<double>? predict(imglib.Image image) {
    if (_interpreter == null) {
      print("Interpreter not initialized");
      return null;
    }
    var startPreprocessForDetect = DateTime.now().millisecondsSinceEpoch;
    TensorImage imageTensor = TensorImage(TfLiteType.float32);
    imageTensor.loadImage(image);
    imageTensor =
        getProcessedImage(imageTensor, _interpreter!.getInputTensor(0).shape);

    TensorBuffer _output = TensorBuffer.createFixedSize(
        _interpreter!.getOutputTensor(0).shape,
        _interpreter!.getOutputTensor(0).type);
    Map<int, ByteBuffer> outputs = {0: _output.buffer};

    // print("interpreter");
    _interpreter!.runForMultipleInputs([imageTensor.buffer], outputs);

    return outputs[0]!.asFloat32List();
  }

  Interpreter? get interpreter => _interpreter;
}

double _meanOf(List<double> imageBufferList) {
  return imageBufferList.reduce((a, b) => a + b) / imageBufferList.length;
}

double _stdOf(List<double> imageBufferList, double mean) {
  double variance = 0;
  imageBufferList.forEach((element) {
    variance = variance + _abs(element - mean) * _abs(element - mean);
  });
  variance = variance / (imageBufferList.length - 1);
  return sqrt(variance);
}

double _abs(double x) {
  return x < 0 ? -x : x;
}
