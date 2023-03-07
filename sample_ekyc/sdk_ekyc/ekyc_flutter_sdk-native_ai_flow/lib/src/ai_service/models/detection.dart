import '../ai_service/models/../../models/landmark.dart';

class Detection {
  final double score;
  final int classID;
  final double xMin;
  final double yMin;
  final double width;
  final double height;
  final List<Landmark> landmark;
  Detection(this.score, this.classID, this.xMin, this.yMin, this.width,
      this.height, this.landmark);

  static List<Landmark> renderLandMarkFromNativeFormat(
      Map<dynamic, dynamic> map) {
    List<Landmark> landmarks = [];
    Landmark leftEye = Landmark(double.parse(map['leftEyeX'].toString()),
        double.parse(map['leftEyeY'].toString()));
    Landmark rightEye = Landmark(double.parse(map['rightEyeX'].toString()),
        double.parse(map['rightEyeY'].toString()));
    Landmark nose = Landmark(double.parse(map['noseX'].toString()),
        double.parse(map['noseY'].toString()));
    Landmark mouth = Landmark(double.parse(map['mouthX'].toString()),
        double.parse(map['mouthY'].toString()));
    Landmark leftCheek = Landmark(double.parse(map['leftCheekX'].toString()),
        double.parse(map['leftCheekY'].toString()));
    Landmark rightCheek = Landmark(double.parse(map['rightCheekX'].toString()),
        double.parse(map['rightCheekY'].toString()));
    landmarks.add(leftEye);
    landmarks.add(rightEye);
    landmarks.add(nose);
    landmarks.add(mouth);
    landmarks.add(leftCheek);
    landmarks.add(rightCheek);
    return landmarks;
  }

  static Detection fromMap(Map<dynamic, dynamic> map) {
    return new Detection(
        double.parse(map['score'].toString()),
        0,
        double.parse(map['xMin'].toString()),
        double.parse(map['yMin'].toString()),
        double.parse(map['width'].toString()),
        double.parse(map['height'].toString()),
        renderLandMarkFromNativeFormat(map));
  }
}
