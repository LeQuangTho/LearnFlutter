// ignore_for_file: file_names

import 'package:hdsaison_signing/src/constants/hard_constants.dart';

import 'localization.dart';

Map<String, String> english = {
  // Languages
  StringKey.vi: 'VN',
  StringKey.en: 'EN',

  // Splash Screen
  StringKey.splashWelcome: "$UNIT_NAME's Signing application",
  StringKey.titleSplash1: 'Easy',
  StringKey.titleSplash2: 'Safe',
  StringKey.titleSplash3: 'Performance',

  // Màn hình Pre Login
  StringKey.preLoginTitle: 'Welcome to $UNIT_NAME_CAP',
  StringKey.preLoginBody:
      'Lorem ipsum non deserunt ullamco est sit aliqua dolor do amet sint.',
  StringKey.preLoginDoYouHavaAccount: 'Do you have account? ',
  StringKey.preLoginRegisterNow: 'Register',
  StringKey.preLoginSignIn: 'Login',

  // Login Screen
  StringKey.account: 'Account',
  StringKey.accountLoginFieldHintext: 'Phone number',
  StringKey.password: 'Password',
  StringKey.passwordLoginFieldHintext: 'Password',
  StringKey.rememberAccount: 'Remember me',
  StringKey.forgotPassword: 'Forgot password?',
  StringKey.notMe: "It's not me",
  StringKey.buttonSignin: 'Login',
  StringKey.dontHaveAcc: 'Bạn chưa có tài khoản? ',
  StringKey.signUpNow: 'Register now',
  StringKey.hotline: 'Liên hệ',
  StringKey.contact: 'Contact',
  StringKey.question: 'Q&A',
  StringKey.scanQr: 'Quét QR',
  StringKey.guide: 'Guide',
  StringKey.joinNow: 'Join Now',
  StringKey.skipButton: 'Skip',
  StringKey.loginToUserService: 'Đăng nhập để sử dụng dịch vụ của $UNIT_NAME_CAP_2',
  StringKey.hello: 'Xin chào',
  StringKey.createAccountSuggestion:
      'Bạn vui lòng tạo 1 tài khoàn hoặc đăng nhập để bắt đầu trải nghiệm.',
  StringKey.login: 'Đăng nhập',

  // Sign up screen
  StringKey.next: 'Next',
  StringKey.signupAppbarText: 'Đăng ký tài khoản',
  StringKey.persionalInformation: 'Thông tin cá nhân',
  StringKey.verifyInformationRecommend:
      'Quý khách vui lòng xác nhận lại thông tin',
  StringKey.fullName: 'Họ và tên',
  StringKey.fullNameHintText: 'Nhập họ và tên',
  StringKey.phoneNumberHinText: 'Nhập số điện thoại',
  StringKey.email: 'Email',
  StringKey.emailHintext: 'Nhập email',
  StringKey.phoneNumber: 'Số điện thoại',
  StringKey.blankFieldErrorText: 'Trường này không được bỏ trống',
  StringKey.cannotFindEmailErrorText: 'Không tìm thấy email',
  StringKey.certificate: 'Chứng chỉ hành nghề',
  StringKey.sYTCode: 'Mã SYT',
  StringKey.invalidFormat: 'Sai định dạng',
  StringKey.agreeWithTermsAndConditionP1: 'Tôi đã đọc và đồng ý với',
  StringKey.agreeWithTermsAndConditionP2: 'điều khoản và điều kiện',
  StringKey.numberHintext: 'Số',

  // Activate account screen

  StringKey.activateAccountAppbarText: 'Kích hoạt tài khoản',
  StringKey.activateAccountSucceedNoti: 'Tài khoản đã được tạo\nthành công',
  StringKey.activateAccountInEmailSuggestionP1: 'Chúng tôi đã gửi email tới',
  StringKey.activateAccountInEmailSuggestionP2:
      'để đảm bảo bạn sở hữu email đó. Vui lòng kiểm tra hộp thư đến và làm theo các hướng dẫn để hoàn tất thiết lập tạo tài khoản của bạn',
  StringKey.resend: 'Gửi lại',
  StringKey.resendActivateEmailInDuration: 'Gửi lại trong',
  StringKey.accountDetails: 'Chi tiết tài khoản',

  // Pop Dialog
  StringKey.backToLoginScreen: 'Quay lại màn hình đăng nhập',
  StringKey.duplicateAccountNoti:
      'Tài khoản của bạn đã được đăng ký sử dụng dịch vụ. Bạn vui lòng đăng nhập để truy cập ứng dụng.',
  StringKey.createAccountSucceed: 'Bạn đã tạo tài khoản thành công.',

  // Forget password screen
  StringKey.forgotPasswordStep1Suggestion:
      'Bạn vui lòng nhập số điện thoại hoặc email đăng ký của bạn để xác minh tài khoản.',
  StringKey.forgotPasswordEnterEmailOfPhoneSuggestion:
      'Nhập số điện thoại hoặc email của bạn',
  StringKey.forgotPasswordEnterEmailOfPhoneHintext:
      'Nhập số điện thoại hoặc email...',
  StringKey.step: 'Bước',

  // OTP screen

  StringKey.otpAppbarText: 'Nhập OTP',
  StringKey.otpSentToYourPhoneNumber:
      'Một mã OTP bao gồm 6 chữ số đã được gửi tới SĐT của bạn ',
  StringKey.otpAvailableDuration: 'Mã OTP có hiệu lực trong: ',
  StringKey.otpHasnotSent: 'Bạn không nhận được mã OTP ?',
  StringKey.otpTryReSend: 'Gửi lại mã',
  StringKey.verifyOtp: 'Xác thực OTP',
  StringKey.verify: 'Xác thực',
  StringKey.changePassword: 'Thay đổi mật khẩu',

  StringKey.setPinSmartOtp: 'Thiết lập PIN cho SmartOTP',
  StringKey.setPinDesc:
      'Mã PIN bao gồm 6 chữ số\nHãy ghi nhớ mã PIN để sử dụng Smart OTP',
  StringKey.enterPin: 'Nhập mã PIN',
  StringKey.reEnterPin: 'Nhập lại mã PIN',
  StringKey.setPinSuccessTitle: 'Cài đặt SmartOTP\nThành công',
  StringKey.setPinSuccessDesc:
      'SmartOTP đã được cài đặt thành công\nMời bạn tiếp tục sử dụng dịch vụ của $UNIT_NAME_CAP',
  StringKey.smartOtpGuideTitle: 'Cài đặt SmartOTP\nBảo mật và thuận tiện hơn',
  StringKey.smartOtpGuideDesc:
      'Smart OTP sẽ giúp bạn chủ động lấy mã OTP ngay trên điện thoại. Mã OTP sẽ được mã hóa và khó có thể can thiệp được',
  StringKey.done: 'Xong',
  StringKey.continueText: 'Tiếp tục',
  StringKey.smartOtpProvision: 'Điều khoản khi sử dụng Smart OTP',
  StringKey.agreeWith: 'Tôi đồng ý với ',

  // Activate eKYC account screen
  StringKey.checkInformationSuggestion:
      'Quý khách vui lòng kiểm tra lại thông tin',
  StringKey.sex: 'Giới tính',
  StringKey.male: 'Nam',
  StringKey.female: 'Nữ',
  StringKey.dateOfBirth: 'Ngày sinh',
  StringKey.idNumber: 'Số CCCD/CMND',
  StringKey.addressInLaw: 'Nơi đăng ký HKTT',
  StringKey.yourEmailWillBeUserForMailOtp:
      'Email của bạn sẽ được sử dụng cho mailOTP',
  StringKey.reportIncorectInfor: 'Báo cáo sai thông tin',

  // Create password screen

  StringKey.createPassword: 'Tạo mật khẩu',
  StringKey.accountName: 'Tên đăng nhập',
  StringKey.newPassword: 'Mật khẩu mới',
  StringKey.confirmPassword: 'Xác nhận mật khẩu',
  StringKey.passwordValidatorLength: 'Mật khẩu từ 7-20 ký tự',
  StringKey.passwordValidatorUpper:
      'Mật khẩu bao gồm ít nhất một ký tự chữ hoa',
  StringKey.passwordValidatorLower:
      'Mật khẩu bao gồm ít nhất một ký tự chữ thường',
  StringKey.passwordValidatorNumberic: 'Mật khẩu bao gồm ít nhất một ký tự số',
  StringKey.passwordValidatorSpecial:
      'Mật khẩu bao gồm it nhất một ký tự đặc biệt sau đây @.,:-_',
  StringKey.confirmPaswordInvalid: 'Mật khẩu không khớp',

  // Toasts

  StringKey.connectionFailure: 'connectionFailure',
  StringKey.connected: 'conntected',
  StringKey.enterYourPhoneNumberToChangeNewPassword:
      'Nhập số điện thoại để đổi mật khẩu',

  // Bottom Navigator Bar
  StringKey.home: 'Trang chủ',
  StringKey.notification: 'Thông báo',
  StringKey.user: 'Cá nhân',

  // Home screen
  StringKey.service: 'Dịch vụ',
  StringKey.support: 'Hỗ trợ',
  StringKey.homeSign: 'Ký hợp đồng vay',
  StringKey.homeQandA: 'Câu hỏi thường gặp',
  StringKey.homeCallSupport: 'Gọi đến tổng đài',
};
