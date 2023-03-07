// ignore_for_file: prefer_final_declarations, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:hdsaison_signing/src/repositories/local/user_local_repository.dart';

import '../../navigations/app_pages.dart';
import 'en_US.dart';
import 'vi_VN.dart';

class StringKey {
  // Languages
  static final String vi = 'vi';
  static final String en = 'en';

  // Splash Screen
  static final String splashWelcome = 'splashWelcome';
  static final String titleSplash1 = 'titleSplash1';
  static final String titleSplash2 = 'titleSplash2';
  static final String titleSplash3 = 'titleSplash3';
  static final String joinNow = 'joinNow';
  static final String skipButton = 'skipButton';
  static final String contact = 'contact';
  static final String question = 'question';
  static final String forgotPasswordEnterEmailOfPhoneSuggestion =
      'forgotPasswordEnterEmailOfPhoneSuggestion';

  //Pre Login
  static final String preLoginTitle = 'preLoginTitle';
  static final String preLoginBody = 'preLoginBody';
  static final String preLoginRegisterNow = 'preLoginRegisterNow';
  static final String preLoginDoYouHavaAccount = 'preLoginDoYouHavaAccount';
  static final String preLoginSignIn = 'preLoginSignIn';

  // Login Screen
  static final String account = 'account';
  static final String accountLoginFieldHintext = 'accountLoginFieldHintext';
  static final String password = 'password';
  static final String passwordLoginFieldHintext = 'passwordLoginFieldHintext';
  static final String rememberAccount = 'rememberAccount';
  static final String forgotPassword = 'fogotPassword';
  static final String notMe = 'notMe';
  static final String buttonSignin = 'buttonSignin';
  static final String dontHaveAcc = 'dontHaveAcc';
  static final String signUpNow = 'signUpNow';
  static final String scanQr = 'scanQr';
  static final String hotline = 'hotline';
  static final String guide = 'guide';
  static final String hello = 'hello';
  static final String createAccountSuggestion = 'createAccountSuggestion';
  static final String login = 'login';
  static final String loginToUserService = 'loginToUserService';

  // Sign up screen

  static final String next = 'next';
  static final String signupAppbarText = 'signupAppbarText';
  static final String persionalInformation = 'persionalInformation';
  static final String verifyInformationRecommend = 'verifyInformationRecommend';
  static final String fullName = 'fullName';
  static final String fullNameHintText = 'fullNameHintText';
  static final String phoneNumberHinText = 'phoneNumberHintext';
  static final String emailHintext = 'emailHintext';
  static final String email = 'email';

  static final String phoneNumber = 'phoneNumber';
  static final String blankFieldErrorText = 'blankFieldErrorText';
  static final String cannotFindEmailErrorText = 'cannotFindEmailErrorText';
  static final String certificate = 'certificate';
  static final String sYTCode = 'sYTCode';
  static final String invalidFormat = 'invalidFormat';
  static final String agreeWithTermsAndConditionP1 =
      'agreeWithTermsAndConditionP1';
  static final String agreeWithTermsAndConditionP2 =
      'agreeWithTermsAndConditionP2';
  static final String numberHintext = 'number';

  // Activate account screeb

  static final String activateAccountAppbarText = 'activateAccountAppbarText';
  static final String activateAccountSucceedNoti = 'activateAccountSucceedNoti';
  static final String activateAccountInEmailSuggestionP1 =
      'activateAccountInEmailSuggestionP1';
  static final String activateAccountInEmailSuggestionP2 =
      'activateAccountInEmailSuggestionP2';
  static final String resend = 'resend';
  static final String resendActivateEmailInDuration =
      'resendActivateEmailInDuration';
  static final String accountDetails = 'accountDetails';

  // Dialog
  static final String backToLoginScreen = 'backToLoginScreen';
  static final String duplicateAccountNoti = 'duplicateAccountNoti';
  static final String createAccountSucceed = 'createAccountSucceed';

  // Forgot password screen
  static final String forgotPasswordAppbarText = 'forgotPasswordAppbarText';
  static final String forgotPasswordStep1Suggestion =
      'forgotPasswordStep1Suggestion';
  static final String enterYourPhoneNumberToChangeNewPassword =
      'enterYourPhoneNumberToChangeNewPassword';
  static final String forgotPasswordEnterEmailOfPhoneHintext =
      'forgotPasswordEnterEmailOfPhoneHintext';
  static final String step = 'step';
  static final String changePassword = 'changePassword';

  // OTP screen
  static final String otpAppbarText = 'otpAppbarText';
  static final String otpSentToYourPhoneNumber = 'otpSentToYourPhoneNumber';
  static final String otpAvailableDuration = 'otpAvailableDuration';
  static final String otpHasnotSent = 'otpHasnotSent';
  static final String otpTryReSend = 'otpTryReSend';
  static final String verifyOtp = 'verifyOtp';
  static final String verify = 'verify';

  static final String setPinSmartOtp = 'setPinSmartOtp';
  static final String setPinDesc = 'setPinDesc';
  static final String enterPin = 'enterPin';
  static final String reEnterPin = 'reEnterPin';
  static final String setPinSuccessTitle = 'setPinSuccessTitle';
  static final String setPinSuccessDesc = 'setPinSuccessDesc';
  static final String smartOtpGuideTitle = 'smartOtpGuideTitle';
  static final String smartOtpGuideDesc = 'smartOtpGuideDesc';
  static final String done = 'done';
  static final String continueText = 'continue';
  static final String smartOtpProvision = 'smartOtpProvision';
  static final String agreeWith = 'agreeWith';

  // Activate eKYC account screen
  static final String checkInformationSuggestion = 'checkInformationSuggestion';
  static final String sex = 'sex';
  static final String male = 'male';
  static final String female = 'female';
  static final String dateOfBirth = 'dateOfBirth';
  static final String idNumber = 'idNumber';
  static final String addressInLaw = 'addressInLaw';
  static final String yourEmailWillBeUserForMailOtp =
      'yourEmailWillBeUserForMailOtp';
  static final String reportIncorectInfor = 'reportIncorectInfor';

  // Create password screen

  static final String createPassword = 'createPassword';
  static final String accountName = 'accoutName';
  static final String newPassword = 'newPassword';
  static final String confirmPassword = 'confirmPassword';
  static final String passwordValidatorLength = 'passwordValidatorLength';
  static final String passwordValidatorUpper = 'passwordValidatorUpper';
  static final String passwordValidatorLower = 'passwordValidatorLower';
  static final String passwordValidatorNumberic = 'passwordValidatorNumberic';
  static final String passwordValidatorSpecial = 'passwordValidatorSpecial';
  static final String confirmPaswordInvalid = 'confirmPaswordValidator';

  // Toasts

  static final String connectionFailure = 'connectionFailure';
  static final String connected = 'conntected';

  // Bottom Navigator Bar
  static final String home = 'home';
  static final String notification = 'notification';
  static final String user = 'user';

  // Home screen
  static final String service = 'service';
  static final String support = 'support';
  static final String homeSign = 'homeSign';
  static final String homeQandA = 'homeQandA';
  static final String homeCallSupport = 'homeCallSupport';
}

class MyI18n {
  static List<String> keys = vietnamese.keys.toList();

  static Map<String, Map<String, String>> getTranslation() {
    Map<String, Map<String, String>> value = {};
    for (var element in keys) {
      value[element] = {
        'vi_vn': vietnamese[element]!,
        'en_us': english[element]!,
      };
    }

    return value;
  }
}

extension Localization on String {
  static final _t = Translations.from('vi_vn', MyI18n.getTranslation());

  String get tr => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}

class LanguageService {
  ///Default Language
  Future<Locale> locale() async {
    final String localeStr = await UserLocalRepository().getCurrentLocale();
    return Locale(localeStr);
  }

  ///List Language support in Application
  static List<Locale> supportLanguage = [
    Locale("en"),
    Locale("vi"),
  ];

  Future<void> changeLanguage(String newLanguageCode) async {
    await UserLocalRepository().saveLocale(newLanguageCode: newLanguageCode);
    print("Event change language running...");
    print("Change language to: " + newLanguageCode);
    I18n.of(AppNavigator.context!).locale = Locale(newLanguageCode);
  }

  initialLanguage(context) async {
    String localeStr = await UserLocalRepository().getCurrentLocale();
    if (localeStr == "vi") {
      I18n.of(context).locale = Locale("vi", "VN");
    } else {
      I18n.of(context).locale = Locale("en", "US");
    }
  }

  static bool getIsLanguage(String locale) {
    return UserLocalRepository().getCurrentLocale() == locale;
  }
}
