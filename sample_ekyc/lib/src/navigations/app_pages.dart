// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/BLOC/ekyc/models/ekyc_eform_response/data.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/dialog_navigation.dart';
import 'package:hdsaison_signing/src/UI/screens/assets_pdf_view_screen/assets_pdf_view_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/change_password/change_password_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/change_password/sub_screens/change_password_fail.dart';
import 'package:hdsaison_signing/src/UI/screens/change_password/sub_screens/change_password_success.dart';
import 'package:hdsaison_signing/src/UI/screens/change_password/sub_screens/check_pass_for_change.dart';
import 'package:hdsaison_signing/src/UI/screens/change_password/sub_screens/confirm_pin_code_change_pass.dart';
import 'package:hdsaison_signing/src/UI/screens/change_password/sub_screens/confirm_smart_otp_change_pass.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/detail_contract_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/change_sign_type_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/check_signature_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/complete_sign_contract_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/confirm_smart_otp.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/detail_pdf_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/draw_signature_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/sign_contract_pin_code.dart';
import 'package:hdsaison_signing/src/UI/screens/digital_certificate/digital_certificate_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/digital_certificate/sub_screen/agree_di_cer.dart';
import 'package:hdsaison_signing/src/UI/screens/digital_certificate/sub_screen/detail_pdf_eform_cts.dart';
import 'package:hdsaison_signing/src/UI/screens/digital_certificate/sub_screen/register_di_cer_success.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/cccd_hc/eKYC_cccd_guide_video.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/cccd_hc/eKYC_cccd_video.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/card_back_validation/card_back_preview_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/card_back_validation/card_back_validation_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/card_front_validation/card_preview_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/card_front_validation/card_validation_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/face_validation/face_validation_preview_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/face_validation/face_validation_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/ekyc_test/failed/ekyc_failed_view.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/face/eKYC_face_guide.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/widgets/camera_permission_request.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/widgets/eKYC_prepare_ocr.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/widgets/eKYC_verify_info_guide.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/widgets/eKYC_verify_info_video.dart';
import 'package:hdsaison_signing/src/UI/screens/ekyc_screen/widgets/eKYC_verify_picture.dart';
import 'package:hdsaison_signing/src/UI/screens/forgot_password/sub_screen/change_pass_forgot.dart';
import 'package:hdsaison_signing/src/UI/screens/forgot_password/sub_screen/verify_otp_forgot_pass.dart';
import 'package:hdsaison_signing/src/UI/screens/home_screen/home_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/pre_login/pre_login_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/sign_contract_screen/sign_contract_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/smart_otp_screen/change_pin_code_screen/change_pin_fail.dart';
import 'package:hdsaison_signing/src/UI/screens/smart_otp_screen/change_pin_code_screen/change_pin_success_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/smart_otp_screen/change_pin_code_screen/old_pin_confirm_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/smart_otp_screen/forgot_pin_code_screen/forgot_pin_code_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/smart_otp_screen/set_pin_screen/pin_code_success_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/smart_otp_screen/set_pin_screen/set_pin_code_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/status_screen/success_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/user_profile/sub_screens/user_info_screen.dart';
import 'package:hdsaison_signing/src/UI/screens/verify_smart_otp/verify_pin_code.dart';
import 'package:hdsaison_signing/src/UI/screens/verify_smart_otp/verify_smart_otp.dart';
import 'package:hdsaison_signing/src/UI/screens/web_view_screen/web_view_screen.dart';

import '../UI/screens/change_password/change_first_pass/verify_otp_change_first_pass_screen.dart';
import '../UI/screens/detail_contract_screen/sub_screen/view_eform.dart';
import '../UI/screens/device_mamagement/active_device_screen.dart';
import '../UI/screens/device_mamagement/device_management_screen.dart';
import '../UI/screens/digital_certificate/sub_screen/check_info_ocr.dart';
import '../UI/screens/digital_certificate/sub_screen/detail_cer.dart';
import '../UI/screens/ekyc_screen/cccd_hc/check_info_cccd.dart';
import '../UI/screens/ekyc_screen/cccd_hc/eKYC_cccd.dart';
import '../UI/screens/ekyc_screen/cccd_hc/eKYC_passport2.dart';
import '../UI/screens/ekyc_screen/face/eKYC_face2.dart';
import '../UI/screens/ekyc_screen/face/eKYC_face_video.dart';
import '../UI/screens/ekyc_screen/face/eKYC_face_video_guide.dart';
import '../UI/screens/ekyc_screen/widgets/eKYC_OCR_success.dart';
import '../UI/screens/ekyc_screen/widgets/eKYC_prepare_add_CTS.dart';
import '../UI/screens/ekyc_screen/widgets/verify_ocr_method.dart';
import '../UI/screens/screens.dart';
import '../UI/screens/smart_otp_screen/change_pin_code_screen/change_pin_code_screen.dart';
import '../UI/screens/smart_otp_screen/smart_otp_screen.dart';
import '../app.dart';
import 'app_navigator_observer.dart';
import 'app_routes.dart';
import 'transition_routes.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route? getRoute(RouteSettings settings) {
    Map<String, dynamic>? arguments = _getArguments(settings);
    switch (settings.name) {
      case Routes.ROOT:
        return _buildRoute(
          settings,
          App(),
        );
      case Routes.LOGIN:
        return _buildRoute(
          settings,
          const LoginScreen(),
        );
      case Routes.FORGOT_PASSWORD:
        return _buildRoute(
          settings,
          ForgotPasswordScreen(username: arguments!['username']),
        );
      case Routes.PRELOGIN:
        return _buildRoute(
          settings,
          const PreLoginScreen(),
        );

      case Routes.CREATE_PASSWORD:
        return _buildRoute(
          settings,
          ChangeFirstPasswordScreen(
            userName: arguments!['userName'],
            password: arguments['passWord'],
          ),
        );
      case Routes.HOME:
        return _buildRoute(
          settings,
          HomeScreen(),
        );

      case Routes.EKYC:
        return _buildRoute(
          settings,
          EKYCScreen(),
        );
      case Routes.EKYC_FACE:
        return _buildRoute(
          settings,
          EKYCFace2(),
        );
      case Routes.EKYC_CCCD:
        return _buildRoute(
          settings,
          const EKYCIDScreen(),
        );
      case Routes.EKYC_PASSPORT:
        return _buildRoute(
          settings,
          const EKYCPassport(),
        );

      case Routes.ACTIVE_DEVICE:
        return _buildRoute(
          settings,
          ActiveDeviceScreen(username: arguments?['username']),
        );

      case Routes.VERIFY_OTP_CHANGE_FIRST_PASS:
        return _buildRoute(
          settings,
          VerifyOtpChangeFirstPassScreen(argument: arguments!),
        );

      case Routes.REGISTER_SUCCESS:
        return _buildRoute(
          settings,
          RegisterSucceedScreen(),
        );

      case Routes.DEVICE_MANAGEMENT:
        return _buildRoute(
          settings,
          DeviceManagementScreen(),
        );

      case Routes.SMART_OTP:
        return _buildRoute(
          settings,
          SmartOTPScreen(),
        );
      case Routes.USER_INFO:
        return _buildRoute(
          settings,
          UserInfoScreen(),
        );
      case Routes.SIGN_CONTRACT:
        return _buildRoute(
          settings,
          SignContractScreen(),
        );
      case Routes.DETAIL_CONTRACT:
        return _buildRoute(
          settings,
          DetailContractScreen(
              idDocument: arguments?['idDocument'],
              nameDocument: arguments?['nameDocument']),
        );

      case Routes.SET_PINCODE:
        return _buildRoute(
          settings,
          PinCodeScreen(),
        );
      case Routes.SET_PINCODE_SUCCESS:
        return _buildRoute(
          settings,
          PinCodeSuccessScreen(),
        );
      case Routes.DRAW_SIGNATURE:
        return _buildRoute(
          settings,
          DrawSignatureScreen(),
        );
      case Routes.CHANGE_SIGN_TYPE:
        return _buildRoute(
          settings,
          ChangeSignTypeScreen(arg: arguments),
        );
      case Routes.CHECK_SIGNATURE:
        return _buildRoute(
          settings,
          CheckSignatureScreen(),
        );
      case Routes.SIGN_CONTRACT_PIN_CODE:
        return _buildRoute(
          settings,
          SignContractPinCode(),
        );
      case Routes.CONFIRM_SMART_OTP:
        return _buildRoute(
          settings,
          ConfirmSmartOtpScreen(),
        );
      case Routes.COMPLETE_SIGN_CONTRACT:
        return _buildRoute(
          settings,
          CompleteSignContractScreen(),
        );
      case Routes.DETAIL_PDF:
        return _buildRoute(
          settings,
          DetailPDFScreen(namePdf: arguments?['namePdf']),
        );
      case Routes.EFORM_PDF:
        return _buildRoute(
          settings,
          ViewEFormScreen(namePdf: arguments?['namePdf']),
        );
      case Routes.OLD_PIN_CONFIRM:
        return _buildRoute(
          settings,
          OldPinConfirmScreen(),
        );
      case Routes.CHANGE_PIN_CODE:
        return _buildRoute(
          settings,
          ChangePinCodeScreen(arg: arguments),
        );
      case Routes.CHANGE_PIN_SUCCESS:
        return _buildRoute(
          settings,
          ChangePinSuccess(),
        );
      case Routes.CHANGE_PIN_FAIL:
        return _buildRoute(
          settings,
          ChangePinFail(),
        );
      case Routes.ASSETS_PDF_VIEW:
        return _buildRoute(
          settings,
          AssetsPDFViewScreen(
            filePath: arguments!['assetsFilePath'],
          ),
        );
      case Routes.WEB_VIEW:
        return _buildRoute(
          settings,
          WebViewScreen(
            link: arguments!['link'],
            title: arguments['title'],
          ),
        );
      case Routes.FORGOT_PIN_CODE:
        return _buildRoute(
          settings,
          ForgotPinCodeScreen(),
        );
      case Routes.CHANGE_PASSWORD_AFTER_LOGIN:
        return _buildRoute(
          settings,
          CheckPassScreen(agruments: arguments),
        );
      case Routes.CHANGE_PASSWORD:
        return _buildRoute(
          settings,
          ChangePasswordScreen(),
        );
      case Routes.CONFIRM_PIN_CHANGE_PASS:
        return _buildRoute(
          settings,
          ConfirmPinCodeChangePass(argument: arguments!),
        );
      case Routes.CONFIRM_SMART_OTP_CHANGE_PASS:
        return _buildRoute(
          settings,
          ConfirmSmartOtpChangePass(argument: arguments!),
        );
      case Routes.DIGITAL_CERTIFICATE:
        return _buildRoute(
          settings,
          DigitalCertificateScreen(),
        );
      case Routes.AGREE_DI_CER:
        return _buildRoute(
          settings,
          AgreeDiCer(
            eform: arguments!['eform'],
          ),
        );
      case Routes.REGISTER_DI_CER_SUCCESS:
        return _buildRoute(
          settings,
          RegisterDiCerSuccess(
            idCTS: arguments!['idCTS'],
          ),
        );
      case Routes.DETAIL_DI_CER:
        return _buildRoute(
          settings,
          DetailDiCertificate(diCer: arguments!['diCer']),
        );

      case Routes.FACE_VALIDATION_VIEW:
        return _buildRoute(
          settings,
          FaceValidationScreen(),
        );
      case Routes.CARD_FRONT_VALIDATION:
        return _buildRoute(
          settings,
          CardFrontValidationScreen(),
        );
      case Routes.PREVIEW_CARD_BACK:
        return _buildRoute(
          settings,
          PreviewCardBackScreen(
              cardValidationResult: arguments?['cardValidationResult'],
              message: arguments?['message'],
              backCardRecogScreenCallback:
                  arguments?['backCardRecogScreenCallback'],
              imagePath: arguments?['cardImagePath'],
              rawImagePath: arguments?['rawCardImagePath']),
        );
      case Routes.PREVIEW_CARD_FRONT:
        return _buildRoute(
          settings,
          PreviewCardScreen(
              cardValidationResult: arguments?['cardValidationResult'],
              message: arguments?['message'],
              backCardRecogScreenCallback:
                  arguments?['backCardRecogScreenCallback'],
              imagePath: arguments?['cardImagePath'],
              rawImagePath: arguments?['rawCardImagePath']),
        );
      case Routes.FACE_VALIDATION_PREVIEW:
        return _buildRoute(
          settings,
          FaceValidationPreview(filePath: arguments?['filePath']),
        );
      case Routes.EKYC_FAILED_VIEW:
        return _buildRoute(
          settings,
          EkycFailedView(message: arguments?['message']),
        );
      case Routes.CARD_BACK_VALIDATION:
        return _buildRoute(
          settings,
          CardBackkValidationScreen(sdkConfig: null),
        );
      case Routes.VERIFY_OTP_FORGOT_PASS:
        return _buildRoute(
          settings,
          VerifyOTPForgotPass(argument: arguments!),
        );
      case Routes.CHANGE_PASS_FORGOT:
        return _buildRoute(
          settings,
          ChangePasswordForgot(argument: arguments!),
        );
      case Routes.CHANGE_PASS_SUCCESS:
        return _buildRoute(
          settings,
          ChangPasswordSuccess(arguments: arguments),
        );
      case Routes.CHANGE_PASS_FAIL:
        return _buildRoute(
          settings,
          ChangePasswordFail(arguments: arguments!),
        );
      case Routes.VERIFY_PIN_CODE:
        return _buildRoute(
          settings,
          VerifyPinCode(arguments: arguments!),
        );
      case Routes.VERIFY_SMART_OTP:
        return _buildRoute(
          settings,
          VerifySmartOtp(arguments: arguments!),
        );
      case Routes.SUCCESS_SCREEN:
        return _buildRoute(
          settings,
          SuccessScreen(arguments: arguments!),
        );
      case Routes.EKYC_VERIFY_PICTURE:
        return _buildRoute(
          settings,
          EKYCVerifyPicture(),
        );
      case Routes.EKYC_CCCD_GUIDE_VIDEO:
        return _buildRoute(
          settings,
          EKYCCccdGuideVideo(),
        );
      case Routes.EKYC_CCCD_VIDEO:
        return _buildRoute(
          settings,
          EKYCIDVideoScreen(),
        );
      case Routes.EKYC_FACE_GUIDE:
        return _buildRoute(
          settings,
          EKYCFaceGuide(
            sdkConfig: null,
          ),
        );
      case Routes.EKYC_FACE_VIDEO_GUIDE:
        return _buildRoute(
          settings,
          EKYCFaceVideoGuide(),
        );
      case Routes.EKYC_FACE_VIDEO:
        return _buildRoute(
          settings,
          EKYCFaceVideoScreen(),
        );
      case Routes.EKYC_PREPARE_OCR:
        return _buildRoute(
          settings,
          EKYCPrepareOCR(),
        );
      case Routes.EKYCE_OCR_SUCCESS:
        return _buildRoute(
          settings,
          EKYCOCRSuccess(),
        );
     
      case Routes.EKYC_VERIFY_INFO_GUIDE:
        return _buildRoute(
          settings,
          EKYCVerifyInfoGuide(),
        );
      case Routes.EKYC_VERIFY_INFO_VIDEO:
        return _buildRoute(
          settings,
          EKYCVerifyInfoVideo(),
        );
      case Routes.DETAIL_PDF_EFORM_CTS:
        return _buildRoute(
          settings,
          DetailPDFEformCTSScreen(),
        );
      case Routes.EKYC_PREPARE_ADD_CTS:
        return _buildRoute(
          settings,
          EKYCPrepareAddCTS(),
        );
      case Routes.CHECK_INFO_CCCD:
        return _buildRoute(
          settings,
          CheckInfoCccd(
            detailOcr: arguments?['detailOcrResponse'],
          ),
        );
      case Routes.CHECK_INFO_OCR:
        return _buildRoute(
          settings,
          CheckInfoOCR(data: arguments?['data'] as EkycEformCTSData),
        );
      case Routes.PERMISSION_CAMERA_REQUEST:
        return _buildRoute(
          settings,
          PermissionCameraRequest(),
        );
      case Routes.VERIFY_OCR_METHOD:
        return _buildRoute(
          settings,
          VerifyOcrMethod(),
        );
      default:
        return null;
    }
  }

  static _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    return AppMaterialPageRoute(
      builder: (context) => builder,
      settings: routeSettings,
    );
  }

  static _getArguments(RouteSettings settings) {
    return settings.arguments;
  }

  static Future push<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamed(route, arguments: arguments);
  }

  static Future pushNamedAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return state.pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String route) {
    state.popUntil(ModalRoute.withName(route));
  }

  static void pop() {
    if (canPop) {
      state.pop();
    }
  }

  static bool get canPop => state.canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;
}
