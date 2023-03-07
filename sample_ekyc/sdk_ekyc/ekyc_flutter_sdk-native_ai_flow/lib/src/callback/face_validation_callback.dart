import 'package:ekyc_flutter_sdk/src/ai_service/models/detection.dart';
import 'package:image/image.dart' as imglib;

typedef void FaceDetectionCallBack(
    List<Detection> detection,
    imglib.Image? img,
    bool detectResult,
    String resultName,
    String message,
    double leftAndRigtPercent);
typedef void FaceLivenessCallBack(
    bool livenessResult, String resultName, String message);

typedef void faceValidationSessionCallBack(
    bool faceValidationResult, String resultName, String message);
