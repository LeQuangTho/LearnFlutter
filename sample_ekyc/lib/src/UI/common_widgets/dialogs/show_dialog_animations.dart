import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/dialog_service_location.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/dialog_loading.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';

import '../../../configs/application.dart';
import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../buttons/button_pop.dart';
import '../buttons/button_primary.dart';
import '../custom_toast/custom_toast.dart';
import 'dialog_confirm.dart';
import 'dialog_lock_account.dart';
import 'dialog_pop.dart';

enum SlideMode {
  left,
  top,
  bot,
  right,
  fade,
}

enum ToastType {
  success,
  error,
  warning,
}

showDialogAlertDuplicateAccount(String? routeName) {
  showDialog(
    context: AppNavigator.context!,
    builder: (context) {
      return DialogPop(
        routeName: routeName,
      );
    },
  );
}

// showDialogNavigation(String routeName, Map<String, dynamic>? argument,
//     String? title, Widget? child, String? content) {
//   showDialog(
//     context: AppNavigator.context!,
//     builder: (context) {
//       return RegisterSucceedScreen(
//         routeName: routeName,
//         argument: argument,
//         child: child,
//         title: title,
//         content: content,
//       );
//     },
//   );
// }

showDialogLoading() {
  showDialog(
    useSafeArea: false,
    context: AppNavigator.context!,
    builder: (context) {
      return DialogLoading();
    },
  );
}

showBottomSheetCustom() {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: ColorsLight.Lv1,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    context: AppNavigator.context!,
    builder: (builder) {
      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mật khẩu đã hết hiệu lực",
                      style: AppTextStyle.textStyle.s20().w700().cN5(),
                    ),
                    Icon(Icons.close)
                  ],
                ),
              ),
              Text.rich(TextSpan(
                  text: "Mật khẩu tạm thời đã hết hiệu lực. Vui lòng chọn ",
                  style: AppTextStyle.textStyle
                      .s14()
                      .w400()
                      .cN5()
                      .copyWith(height: 1.5),
                  children: [
                    TextSpan(
                        text: "Cấp lại",
                        style: AppTextStyle.textStyle
                            .s14()
                            .w700()
                            .cN5()
                            .copyWith(height: 1.5),
                        children: [
                          TextSpan(
                            text: " mật khẩu tạm thời",
                            style: AppTextStyle.textStyle.s14().w400().cN5(),
                          )
                        ])
                  ])),
              Row(
                children: [
                  Expanded(
                    child: ButtonPop2(
                        buttonTitle: 'Đóng',
                        colorButton: ColorsPrimary.Lv5,
                        colorText: ColorsPrimary.Lv2
                        // onTap: () {},

                        ),
                  ),
                  SizedBox(width: 13.px),
                  Expanded(
                    child: ButtonPrimary(
                      content: 'Cấp lại',
                      onTap: () async {},
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
    },
  );
}

showDialogRequestPermissionLocaion(bool isSign) {
  showDialog(
    useSafeArea: false,
    context: AppNavigator.context!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return DialogServiceLocation(
        isSign: isSign,
      );
    },
  );
}

showDialogConfirm(
    {required String title,
    required String body,
    String? textConfirm,
    required Function() action,
    String? textClose}) {
  showDialog(
    useSafeArea: false,
    context: AppNavigator.context!,
    builder: (builder) {
      return DialogConfirm(
          title: title,
          body: body,
          textConfirm: textConfirm,
          action: action,
          textClose: textClose);
    },
  );
}

showDialogLockAccount() {
  showDialog(
    useSafeArea: false,
    context: AppNavigator.context!,
    builder: (builder) {
      return DialogLockAccount();
    },
  );
}

showDialogBio({String title = "", String body = ""}) {
  showDialog(
    useSafeArea: false,
    context: AppNavigator.context!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return DialogBiometric(
        title: title,
        body: body,
      );
    },
  );
}

showToast(ToastType type, {String? title = 'Có lỗi xảy ra'}) async {
  await dialogAnimationWrapper(
      type: type,
      timeForDismiss: 2000,
      slideFrom: SlideMode.top,
      child: CustomToast(
        type: type,
        title: title,
      ));
}

Future dialogAnimationWrapper({
  required ToastType type,
  SlideMode slideFrom = SlideMode.left,
  child,
  duration = 400,
  paddingTop = 0.0,
  paddingBottom = 0.0,
  backgroundColor = Colors.white,
  paddingHorizontal = 15.0,
  borderRadius = 25.0,
  dismissible = true,
  barrierColor,
  timeForDismiss,
}) {
  var beginOffset = Offset(-1, 0);
  switch (slideFrom) {
    case SlideMode.left:
      beginOffset = Offset(-1, 0);
      break;
    case SlideMode.right:
      beginOffset = Offset(1, 0);
      break;
    case SlideMode.top:
      beginOffset = Offset(0, -1);
      break;
    default:
      beginOffset = Offset(0, 1);
      break;
  }

  if (timeForDismiss != null) {
    Future.delayed(Duration(milliseconds: timeForDismiss), () {
      AppData.isShowingError = false;
      AppNavigator.pop();
    });
  }

  return showGeneralDialog(
    barrierLabel: "Barrier",
    transitionDuration: Duration(milliseconds: duration),
    context: AppNavigator.context!,
    pageBuilder: (_, __, ___) {
      return child;
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: beginOffset, end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

Future<dynamic> showDialogMissInfo(BuildContext context) {
  return showDialog(
    context: context,
    builder: (dialogCtx) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.px),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.px),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 24.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppAssetsLinks.ic_warning3),
              SizedBox(height: 24.px),
              Text(
                'Vui lòng cập nhật đầy đủ email và địa chỉ hiện tại để sử dụng tính năng này.',
                style: AppTextStyle.textStyle.s16().w400().cN4(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.px),
              Row(
                children: [
                  Expanded(
                    child: ButtonPop2(
                      height: 48.px,
                      buttonTitle: 'Quay lại',
                    ),
                  ),
                  SizedBox(width: 8.px),
                  Expanded(
                    child: ButtonPrimary(
                      padding: EdgeInsets.zero,
                      height: 48.px,
                      onTap: () {
                        AppNavigator.pop();
                        AppNavigator.push(Routes.USER_INFO);
                      },
                      content: 'Cập nhật',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
