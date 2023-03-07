import 'package:flutter/material.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.imageSize, this.results);
  final Size imageSize;
  late double scaleX, scaleY;
  dynamic results;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.greenAccent;

    var tmp;
    for (tmp in results) {
      scaleX = size.width / imageSize.height;
      scaleY = size.height / imageSize.width;
      double x = tmp[0];
      double y = tmp[1];
      double w = (tmp[2] - tmp[0]);
      double h = (tmp[3] - tmp[1]);
      if (imageSize.width > imageSize.height) {
        canvas.drawRect(
            Rect.fromLTWH(size.width - (x + w + w * 0.2) * scaleX, y * scaleY,
                (w + w * 0.4) * scaleX, (h - h * 0.1) * scaleY),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.results != results;
  }
}

RRect _scaleRect(
    {@required Rect? rect,
    @required Size? imageSize,
    @required Size? widgetSize,
    double? scaleX,
    double? scaleY}) {
  return RRect.fromLTRBR(
      (widgetSize!.width - rect!.left.toDouble() * scaleX!),
      rect.top.toDouble() * scaleY!,
      widgetSize.width - rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
      Radius.circular(10));
}
