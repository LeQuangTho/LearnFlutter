import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as imglib;
import 'package:sample_sdk_flutter/src/utils/api_utils/api_helper.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/utils/server_error_code_handler.dart';

import '../../../../../helpers/untils/logger.dart';
import '../../../../../navigations/app_pages.dart';
import '../../../../../navigations/app_routes.dart';
import '../../../../common_widgets/buttons/button_pop.dart';
import '../../../../common_widgets/buttons/button_primary.dart';
import '../../../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../../../designs/app_themes/app_assets_links.dart';
import '../../../../designs/app_themes/app_colors.dart';
import '../../../../designs/app_themes/app_text_styles.dart';
import '../../../../designs/layouts/appbar_common.dart';
import '../../../../designs/sizer_custom/sizer.dart';
import '../../widgets/card_overlay_shape.dart';

// ignore: must_be_immutable
class PreviewCardBackScreen extends StatefulWidget {
  imglib.Image? imShow;
  String? rawImagePath;
  String? imagePath;
  late bool cardValidationResult;
  late String message;

  Future<void> Function() backCardRecogScreenCallback;

  PreviewCardBackScreen(
      {Key? key,
      required this.cardValidationResult,
      required this.message,
      required this.backCardRecogScreenCallback,
      this.imShow,
      this.imagePath,
      this.rawImagePath})
      : super(key: key);

  @override
  _PreviewCardBackScreenState createState() => _PreviewCardBackScreenState();
}

class _PreviewCardBackScreenState extends State<PreviewCardBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      // extendBodyBehindAppBar: true,
      appBar: MyAppBar("Xác định danh tính"),
      body: Column(
        children: [
          Spacer(),
          Container(
            decoration: ShapeDecoration(
              shape: CardOverlayShape(
                borderColor: widget.cardValidationResult == true
                    ? ColorsSuccess.Lv1
                    : ColorsPrimary.Lv1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.px),
              child: widget.imagePath == null
                  ? SvgPicture.asset(AppAssetsLinks.cccdfront)
                  : Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
                  color: widget.cardValidationResult == true
                      ? ColorsSuccess.Lv1
                      : ColorsPrimary.Lv1,
                  child: Text(
                    '${widget.message}',
                    style: AppTextStyle.textStyle.s12().w700().cW5(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.px, 16.px, 20.px, 42.px),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          widget.cardValidationResult == true
                              ? AppAssetsLinks.success
                              : AppAssetsLinks.fail,
                          height: 56.px),
                      SizedBox(height: 8.px),
                      Text(
                          widget.cardValidationResult == true
                              ? 'Hoàn thành'
                              : 'Không hợp lệ',
                          style: AppTextStyle.textStyle.s16().w500().cN5()),
                      SizedBox(height: 24.px),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonPop2(
                              onTap: () {
                                AppNavigator.pop();
                              },
                              buttonTitle: 'Chụp lại',
                              colorText: ColorsPrimary.Lv1,
                              colorButton: ColorsPrimary.Lv5,
                            ),
                          ),
                          if (widget.cardValidationResult == true)
                            SizedBox(width: 20.px),
                          if (widget.cardValidationResult == true)
                            Expanded(
                              child: ButtonPrimary(
                                onTap: widget.rawImagePath == null
                                    ? () {}
                                    : () async {
                                        showDialogLoading();
                                        var response =
                                            await ApiHelper.uploadCardBack(
                                                widget.rawImagePath ?? '');
                                        UtilLogger.log(
                                            'Response uploadCardBack',
                                            response.toJson());
                                        if (response.output != null &&
                                            response.code == "SUCCESS") {
                                          if (AppConfig().sdkCallback != null) {
                                            AppConfig()
                                                .sdkCallback!
                                                .backCardCloudCheck(
                                                    true, "", "");
                                          }
                                          AppNavigator.pop();
                                          AppNavigator.push(
                                              Routes.EKYC_CCCD_GUIDE_VIDEO);
                                        } else {
                                          if (response.error != null) {
                                            if (AppConfig().sdkCallback !=
                                                null) {
                                              AppConfig()
                                                  .sdkCallback!
                                                  .backCardCloudCheck(
                                                      false,
                                                      response.error!,
                                                      getMessageFromErrorCode(
                                                          response.code));
                                            }
                                          }
                                          if (response.code == "TIMEOUT") {
                                            Navigator.pop(context);
                                            showToast(ToastType.error,
                                                title: getMessageFromErrorCode(
                                                    response.code));
                                          } else {
                                            Navigator.pop(context);
                                            showToast(ToastType.error,
                                                title: getMessageFromErrorCode(
                                                    response.code));
                                          }
                                        }
                                      },
                                content: 'Sử dụng',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
