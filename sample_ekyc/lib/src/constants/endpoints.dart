class Endpoints {
  static final String login = 'mobile/login';
  static final String logOut = 'mobile/logout';
  static final String checkUserExist = 'mobile/check-username/';
  static final String resetTempPassword = 'mobile/reset-temppassworduration';
  static final String userInfor = 'mobile/profile';
  static final String addFirebaseToken = 'mobile/device/add-firebase-token';
  static final String countContract = 'mobile/document/count';
  static final String listStatusContract = 'mobile/document/liststatus';
  static final String listDigitalCertificate = 'mobile/certificate';
  static final String listContract = 'mobile/document/filter';
  static final String detailContract = 'mobile/document/';
  static final String requestSign = 'mobile/document/sign/request';
  static final String signEForm = 'mobile/eform/sign';
  static final String confirmSign = 'mobile/document/sign/confirm';
  static final String changePassword = 'mobile/change-password';
  static final String changeFirstPassword = 'mobile/change-first-password';
  static final String activeDevice = 'mobile/device/update-status';
  static final String getOtpChangePass = 'mobile/send-otp-change-password';
  static final String getOtp = 'mobile/Send-SMS-OTP';
  static final String getOtpForgotPass = 'mobile/send-smsotp-forgot-password';
  static final String verifyOtpForgotPass = 'mobile/check-SMSOTP';
  static final String verifyOtp = 'mobile/check-SMS-OTP';
  static final String changePassForgotPass = 'mobile/forget-password';
  static final String checkCurrentPassword = 'mobile/check-password';
  static final String getSmartOTP = 'mobile/send-smartotp';
  static final String verifySmartOTP = 'mobile/check-smartOTP';
  static final String refuseSign = 'mobile/document/reject';
  static final String updateProfile = 'mobile/profile/update';

  static String getDetailCTS(String? id) {
    return 'mobile/certificate/{$id}';
  }

  static const String createEformRequestCertificate = 'mobile/eform/create';

  static const String createOrUpdateOCRInfo = 'mobile/ocr/createorupdateinfo';

  static const String confirmEformRequestCertificate = 'mobile/eform/confirm';

  static const String addCTS = 'mobile/certificate/add';

  static const String checkSignature = 'mobile/document/verify';

  static const String uploadFile = 'mobile/authentication/upload-file';

  static const String listDevice = 'mobile/device/list';
  static const String getDetailOcrInfo = 'mobile/ocr/detail';
  static const String cancelDevice = 'mobile/device/disconnect';

  static const String listNotification =
      'mobile/notification/ListNotificationByUser';
  static const String readNotification = 'mobile/change-isread';
}
