import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// クレカ標準の比
const _CARD_ASPECT_RATIO = 1 / 1.5;
// const _CARD_ASPECT_RATIO = 1 / 1.618;
// 横の枠線marginを決める時用のfactor
// 横幅の5%のサイズのmarginをとる
const _OFFSET_X_FACTOR = 0.05;

class CardScannerOverlayShape extends ShapeBorder {
  CardScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
    // this.overlayColor = const Color.fromRGBO(0, 0, 0, 60),
    this.overlayColor = const Color.fromARGB(255, 255, 255, 255),
    this.borderRadius = 6,
    this.borderLength = 32,
    this.cutOutBottomOffset = 0,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutBottomOffset;

  // int? _left, _top, _height, _width;
  // bool _isAddMaskShape = false;
  // int get_left() {
  //   return _left!;
  // }

  // int get_top() {
  //   return _top!;
  // }

  // int get_height() {
  //   return _height!;
  // }

  // int get_heidth() {
  //   return _width!;
  // }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // print("size overlay ${rect.width}");
    // print("size overlay ${rect.height}");
    final offsetX = rect.width * _OFFSET_X_FACTOR;
    final cardWidth = rect.width - offsetX * 2;
    final cardHeight = cardWidth * _CARD_ASPECT_RATIO;
    final offsetY = (rect.height - cardHeight) / 2;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + offsetX,
      rect.top + offsetY,
      cardWidth,
      cardHeight,
    );

    // print("hubert RectLeft= " + rect.left.round().toString());
    // print("hubert RectTop= " + rect.top.round().toString());
    // print("hubert RectWidth= " + rect.width.round().toString());
    // print("hubert RectHeight= " + rect.height.round().toString());
    // print("hubert offsetX  = " + offsetX.toString());
    // print("hubert offsetY  = " + offsetY.toString());
    // print("hubert Left = " + (rect.left + offsetX).round().toString());
    // print("hubert Top = " + (rect.top + offsetY).round().toString());
    // print("hubert Height = " + cardHeight.round().toString());
    // print("hubert Width = " + cardWidth.round().toString());

    // if (!_isAddMaskShape) {
    //   print("add mask shape");
    //   this._left = (rect.left + offsetX).round();
    //   this._top = (rect.top + offsetY).round();
    //   this._height = cardHeight.round();
    //   print("add mask shape height = " + this._height.toString());
    //   this._width = cardWidth.round();
    //   _isAddMaskShape = true;
    // }

    // canvas
    //   ..saveLayer(
    //     rect,
    //     backgroundPaint,
    //   )
    //   ..drawRect(
    //     rect,
    //     backgroundPaint,
    //   )
    //   ..drawOval(cutOutRect, boxPaint)
    //   ..drawOval(cutOutRect, borderPaint)
    //   ..restore()
    //   ..restore();

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      ..drawRRect(
          RRect.fromRectXY(cutOutRect, borderRadius, borderRadius), borderPaint)
      // // Draw top right corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.right - borderLength,
      //     cutOutRect.top,
      //     cutOutRect.right,
      //     cutOutRect.top + borderLength,
      //     topRight: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw top left corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.left,
      //     cutOutRect.top,
      //     cutOutRect.left + borderLength,
      //     cutOutRect.top + borderLength,
      //     topLeft: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw bottom right corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.right - borderLength,
      //     cutOutRect.bottom - borderLength,
      //     cutOutRect.right,
      //     cutOutRect.bottom,
      //     bottomRight: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw bottom left corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.left,
      //     cutOutRect.bottom - borderLength,
      //     cutOutRect.left + borderLength,
      //     cutOutRect.bottom,
      //     bottomLeft: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )

      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return CardScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
