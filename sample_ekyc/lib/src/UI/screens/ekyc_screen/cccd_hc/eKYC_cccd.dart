import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class EKYCIDScreen extends StatefulWidget {
  const EKYCIDScreen({Key? key}) : super(key: key);

  @override
  State<EKYCIDScreen> createState() => _EKYCIDScreenState();
}

class _EKYCIDScreenState extends State<EKYCIDScreen> {
  @override
  void initState() {
    super.initState();
    AppBlocs.ekycBloc.add(EkycMovingForwardStepEvent(newStep: 1));
    AppBlocs.ekycBloc.add(EkycSetupFirstCameraEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkycBloc, EkycState>(
      builder: (context, state) {
        if (state is EkycCameraReadyState) {
          return Scaffold(
            appBar: MyAppBar('Xác thực CCCD/CMND'),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CameraPreview(
                    state.cameraController,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: CCCDOverlayShape(),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: ColorsLight.Lv1,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.px, vertical: 16.px),
                        color:
                            (state.currentStep == 2 || state.currentStep == 4)
                                ? ColorsSuccess.Lv1
                                : ColorsPrimary.Lv1,
                        child: Text(
                          'Vui lòng đặt CCCD/CMND nằm trong vùng chọn. Ảnh chụp trong điều kiện đủ sáng, rõ nét.',
                          style: AppTextStyle.textStyle.s12().w700().cW5(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildButtonUsePhotoOrNot(state)
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return BackgroundStack(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 8.px,
                ),
                Text('Đang xử lý...',
                    style: AppTextStyle.textStyle.s16().w500().cN1()),
                SizedBox(
                  height: 16.px,
                ),
                Text(
                  'Quá trình này có thể mất đến 30 giây. Vui lòng không tắt hoặc thoát ứng dụng.',
                  style: AppTextStyle.textStyle.s16().w500().cN1(),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonUsePhotoOrNot(EkycCameraReadyState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.px, 16.px, 20.px, 42.px),
      child: Column(
        children: (state.currentStep == 2 || state.currentStep == 4)
            ? [
                SvgPicture.asset(AppAssetsLinks.success, height: 56.px),
                SizedBox(height: 8.px),
                Text('Hoàn thành',
                    style: AppTextStyle.textStyle.s16().w500().cG5()),
                SizedBox(height: 24.px),
                Row(
                  children: [
                    Expanded(
                      child: ButtonPop2(
                        onTap: () {
                          if (state.currentStep == 2) {
                            AppBlocs.ekycBloc
                                .add(EkycMovingForwardStepEvent(newStep: 1));
                            AppBlocs.ekycBloc.add(EkycSetupFirstCameraEvent());
                          } else if (state.currentStep == 4) {
                            AppBlocs.ekycBloc
                                .add(EkycMovingForwardStepEvent(newStep: 3));
                            AppBlocs.ekycBloc.add(EkycSetupFirstCameraEvent());
                          }
                        },
                        buttonTitle: 'Chụp lại',
                        colorText: ColorsPrimary.Lv1,
                        colorButton: ColorsPrimary.Lv5,
                      ),
                    ),
                    SizedBox(width: 20.px),
                    Expanded(
                      child: ButtonPrimary(
                        onTap: () {
                          if (state.currentStep == 2) {
                            AppBlocs.ekycBloc.add(EkycUploadFileEvent(
                              file: File(
                                  AppBlocs.ekycBloc.images['front']?.path ??
                                      ''),
                              fileName: 'id_card_front',
                            ));
                            AppBlocs.ekycBloc
                                .add(EkycMovingForwardStepEvent(newStep: 3));
                            AppBlocs.ekycBloc.add(EkycSetupFirstCameraEvent());
                          } else if (state.currentStep == 4) {
                            AppBlocs.ekycBloc.add(EkycUploadFileEvent(
                              file: File(
                                  AppBlocs.ekycBloc.images['back']?.path ?? ''),
                              fileName: 'id_card_back',
                              routeReplace: Routes.EKYC_CCCD_GUIDE_VIDEO,
                            ));
                          }
                        },
                        content: 'Sử dụng',
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ]
            : [
                SvgPicture.asset(state.currentStep == 1
                    ? AppAssetsLinks.cccdfront
                    : AppAssetsLinks.cccdback),
                SizedBox(height: 8.px),
                Text(
                  state.currentStep == 1
                      ? 'Chụp mặt trước của CCCD/CMND'
                      : 'Chụp mặt sau của CCCD/CMND',
                  style: AppTextStyle.textStyle.s16().w500().cN5(),
                ),
                SizedBox(height: 20.px),
                GestureDetector(
                  onTap: () {
                    if (state.currentStep == 1) {
                      AppBlocs.ekycBloc.add(EkycTakeFrontPictureEvent());
                    } else if (state.currentStep == 3) {
                      AppBlocs.ekycBloc.add(EkycTakeBackPictureEvent());
                    }
                  },
                  child: Container(
                    width: 66.px,
                    height: 66.px,
                    decoration: BoxDecoration(
                      color: ColorsPrimary.Lv5,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 60.px,
                        height: 60.px,
                        decoration: BoxDecoration(
                          color: ColorsPrimary.Lv1,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4.px,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}

class SquareHole extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = ColorsLight.Lv1;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(
              0, 0, size.width, size.height, Radius.circular(0))),
        Path()
          ..addRRect(RRect.fromLTRBR(
              0, size.height * 0.6, size.width, 0.px, Radius.circular(0)))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CCCDOverlayShape extends ShapeBorder {
  CCCDOverlayShape({
    this.borderColor = ColorsPrimary.Lv1,
    this.borderWidth = 6.0,
    this.overlayColor = const Color.fromRGBO(255, 255, 255, 80),
    this.borderRadius = 10,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 280.px,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 175.px {
    assert(
      borderLength <=
          min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
        (cutOutWidth == null && cutOutHeight == null) ||
            (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
        'Use only cutOutWidth and cutOutHeight or only cutOutSize');
  }

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;

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
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength =
        borderLength > min(cutOutHeight, cutOutHeight) / 2 + borderWidth * 2
            ? borderWidthSize / 2
            : borderLength;
    final _cutOutWidth =
        cutOutWidth < width ? cutOutWidth : width - borderOffset;
    final _cutOutHeight =
        cutOutHeight < height ? cutOutHeight : height - borderOffset;

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
      rect.left + width / 2 - _cutOutWidth / 2 + borderOffset,
      rect.top + 104.px + borderOffset * 2,
      _cutOutWidth - borderOffset * 2,
      _cutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength / 2,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + _borderLength / 2,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + _borderLength / 2,
          cutOutRect.top + _borderLength / 2,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength / 2,
          cutOutRect.bottom - _borderLength / 2,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - _borderLength / 2,
          cutOutRect.left + _borderLength / 2,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
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
    return CCCDOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
