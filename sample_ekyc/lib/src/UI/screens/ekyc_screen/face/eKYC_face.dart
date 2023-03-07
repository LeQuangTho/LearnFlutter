import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../../navigations/app_pages.dart';
import '../../../common_widgets/dialogs/dialog_loading.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';

class EKYCFaceScreen extends StatefulWidget {
  EKYCFaceScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EKYCFaceScreen> createState() => _EKYCFaceScreenState();
}

class _EKYCFaceScreenState extends State<EKYCFaceScreen> {
  @override
  void initState() {
    super.initState();
    AppBlocs.ekycBloc.add(EkycSetupSecondaryCameraEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void nextStep() async {
    AppBlocs.ekycBloc.add(EkycMovingForwardStepEvent(newStep: 2));
    await AppNavigator.push(Routes.EKYC);
    AppBlocs.ekycBloc.add(EkycSetupSecondaryCameraEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkycBloc, EkycState>(
      builder: (context, state) {
        if (state is EkycCameraReadyState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              actions: [
                SizedBox(
                  width: 50.px,
                )
              ],
              backgroundColor: ColorsDark.Lv1,
              title: Center(
                child: Text(
                  'Xác thực khuôn mặt',
                  style: AppTextStyle.textStyle.s16().w400().cW5(),
                ),
              ),
              elevation: 0.0,
              leading: InkWell(
                onTap: () {
                  AppNavigator.pop();
                  AppBlocs.ekycBloc.add(EkycMovingForwardStepEvent(newStep: 0));
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20.px),
                  child: SvgPicture.asset(
                    AppAssetsLinks.ic_arrow_left,
                    color: ColorsNeutral.Lv5,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            body: Container(
              child: CameraPreview(
                state.cameraController,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: Hole(),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.px),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40.px,
                              ),
                              Text(
                                state.currentStep == 1
                                    ? ' \n '
                                    : 'Khuôn mặt hướng thẳng vào camera,\nnằm chính giữa vùng chọn.',
                                textAlign: TextAlign.center,
                                style:
                                    AppTextStyle.textStyle.s16().w400().cN2(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.px,
                        ),
                        Container(
                          width: 280.px,
                          height: 280.px,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorsNeutral.Lv3,
                              width: 4.px,
                            ),
                          ),
                        ),
                        state.currentStep == 1
                            ? Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.px),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.px),
                                        child: Text(
                                          'Vui lòng kiểm tra ảnh chụp khuôn mặt.\nBạn có muốn sử dụng ảnh này để xác thực?',
                                          style: AppTextStyle.textStyle
                                              .s16()
                                              .w400()
                                              .cN2(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 30.px),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                AppBlocs.ekycBloc.add(
                                                    EkycMovingForwardStepEvent(
                                                        newStep: 0));
                                                AppBlocs.ekycBloc.add(
                                                    EkycSetupSecondaryCameraEvent());
                                              },
                                              child: Container(
                                                height: 48,
                                                width: 162.px,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.px),
                                                    color: ColorsSuccess.Lv2),
                                                child: Center(
                                                  child: Text(
                                                    'Chụp lại',
                                                    style: AppTextStyle
                                                        .textStyle
                                                        .s16()
                                                        .w500()
                                                        .cW5(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.px,
                                            ),
                                            InkWell(
                                              onTap: nextStep,
                                              child: Container(
                                                height: 48,
                                                width: 162.px,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.px),
                                                    color: ColorsPrimary.Lv2),
                                                child: Center(
                                                  child: Text(
                                                    'Sử dụng',
                                                    style: AppTextStyle
                                                        .textStyle
                                                        .s16()
                                                        .w500()
                                                        .cW5(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 60.px),
                                      child: GestureDetector(
                                        onTap: () {
                                          AppBlocs.ekycBloc
                                              .add(EkycTakeFacePictureEvent());
                                        },
                                        child: Container(
                                          width: 66.px,
                                          height: 66.px,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 56.px,
                                              height: 56.px,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.px,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return DialogLoading();
      },
    );
  }
}

class Hole extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = ColorsDark.Lv1;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(
              0, 0, size.width, size.height, Radius.circular(0))),
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2 - 75.px),
              radius: 136.px))
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
