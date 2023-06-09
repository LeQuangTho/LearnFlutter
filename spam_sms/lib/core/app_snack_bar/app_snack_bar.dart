import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:spam_sms/core/theme/app_text_style.dart';
import 'package:spam_sms/core/theme/gen/colors.gen.dart';

mixin AppSnackBar {
  static Color _backgroundSnackBar = Colors.black87;
  static Duration _animationDurationSnackBar =
      const Duration(milliseconds: 234);
  static Duration _durationSnackBar = const Duration(seconds: 2);

  static void showWarning(
    String content, {
    Callback? onDone,
  }) {
    Get.snackbar(
      content,
      '',
      icon: const Padding(
        padding: EdgeInsets.only(bottom: 3),
        child: Icon(
          Icons.warning,
          color: AppColor.orange400,
        ),
      ),
      animationDuration: _animationDurationSnackBar,
      duration: _durationSnackBar,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 6,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeInOut,
      messageText: Container(),
      backgroundColor: _backgroundSnackBar,
      titleText: Text(
        content,
        style: AppStyle.bodyRegular.oneLine.white,
        maxLines: 3,
      ),
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          Future.delayed(const Duration(milliseconds: 100), onDone);
        }
      },
    );
  }

  static void showError(
    String content, {
    Callback? onDone,
    Widget? suffix,
  }) {
    Get.snackbar(
      content,
      '',
      icon: const Padding(
        padding: EdgeInsets.only(bottom: 3),
        child: Icon(
          Icons.warning,
          color: AppColor.red600,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: _animationDurationSnackBar,
      duration: _durationSnackBar,
      borderRadius: 6,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeInOut,
      messageText: Container(),
      backgroundColor: _backgroundSnackBar,
      titleText: Row(
        children: [
          Expanded(
            child: Text(
              content,
              style: AppStyle.bodyRegular.oneLine.white,
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 8),
          suffix ?? const SizedBox(),
        ],
      ),
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          Future.delayed(const Duration(milliseconds: 100), onDone);
        }
      },
    );
  }

  static void showSuccess(
    String content, {
    Callback? onDone,
    Widget? suffix,
  }) {
    Get.snackbar(
      content,
      '',
      animationDuration: _animationDurationSnackBar,
      duration: _durationSnackBar,
      icon: const Padding(
        padding: EdgeInsets.only(bottom: 3),
        child: Icon(
          Icons.check_circle,
          color: AppColor.green300,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 6,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeInOut,
      messageText: Container(),
      backgroundColor: _backgroundSnackBar,
      titleText: Row(
        children: [
          Expanded(
            child: Text(
              content,
              style: AppStyle.bodyRegular.oneLine.white,
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 8),
          suffix ?? const SizedBox(),
        ],
      ),
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          Future.delayed(const Duration(milliseconds: 100), onDone);
        }
      },
    );
  }
}
