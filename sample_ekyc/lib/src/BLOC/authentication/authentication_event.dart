part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationCheckRememberedAccountEvent extends AuthenticationEvent {}

class AuthenticationClearRememberedAccountEvent extends AuthenticationEvent {}

class AuthenticationAddFirebaseTokenEnableLocationEvent
    extends AuthenticationEvent {}

class AuthenticationAddFirebaseTokenDisableLocationEvent
    extends AuthenticationEvent {}


class AuthenticationTryResendVerifiEmailEvent extends AuthenticationEvent {
  final String registerToken;
  AuthenticationTryResendVerifiEmailEvent({
    required this.registerToken,
  });
}

class AuthenticationChangeFirstPasswordEvent extends AuthenticationEvent {
  final CreatePasswordForm2 createPasswordForm;
  final String userId;
  final String userName;
  final bool isNewDevice;
  AuthenticationChangeFirstPasswordEvent({
    required this.createPasswordForm,
    required this.userName,
    required this.userId,
    required this.isNewDevice,
  });
}
class AuthenticationActiveDeviceEvent extends AuthenticationEvent {
  final String userName;
  final String otp;
  AuthenticationActiveDeviceEvent({
    required this.userName,
    required this.otp,
  });
}

class AuthenticationGetOTPChangeFirstPassEvent extends AuthenticationEvent {
  final CreatePasswordForm2 createPasswordForm;
  final String userId;
  final String userName;
  AuthenticationGetOTPChangeFirstPassEvent({
    required this.createPasswordForm,
    required this.userId,
    required this.userName,
  });
}

class AuthenticationGetOTPEvent extends AuthenticationEvent {
  final String userName;
  AuthenticationGetOTPEvent({
    required this.userName,
  });
}

class AuthenticationResendOTPChangeFirstPassEvent extends AuthenticationEvent {}

class AuthenticationResendOTPEvent extends AuthenticationEvent {}

class AuthenticationChangePasswordAfterLoginEvent extends AuthenticationEvent {
  final String newPassword;
  final String oldPassword;
  final String otp;
  AuthenticationChangePasswordAfterLoginEvent({
    required this.newPassword,
    required this.oldPassword,
    required this.otp,
  });
}

class AuthenticationChangePasswordForgotEvent extends AuthenticationEvent {
  final String newPassword;
  final String phoneNumber;
  final String otp;
  AuthenticationChangePasswordForgotEvent({
    required this.otp,
    required this.phoneNumber,
    required this.newPassword,
  });
}

class AuthenticationGetSmartOtpEvent extends AuthenticationEvent {}

class AuthenticationVerifySmartOtpEvent extends AuthenticationEvent {
  final String smartOtp;
  final String? routeSuccess;
  final String? routeFail;
  final Callback? action;
  final Map<String, dynamic>? arg;
  AuthenticationVerifySmartOtpEvent({
    required this.smartOtp,
    this.routeSuccess,
    this.routeFail,
    this.arg,
    this.action,
  });
}

class AuthenticationResetTempPasswordEvent extends AuthenticationEvent {
  final String phoneNumber;
  AuthenticationResetTempPasswordEvent({
    required this.phoneNumber,
  });
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String username;
  final String password;
  final bool remember;
  AuthenticationLoginEvent({
    required this.username,
    required this.password,
    required this.remember,
  });
}

class AuthenticationCheckUserExistEvent extends AuthenticationEvent {
  final String username;
  AuthenticationCheckUserExistEvent({
    required this.username,
  });
}

//* Quên mật khẩu
class AuthenticationGetOtpForgotPasswordEvent extends AuthenticationEvent {
  final String phoneNumber;
  AuthenticationGetOtpForgotPasswordEvent({
    required this.phoneNumber,
  });
}

class AuthenticationResendOTPForgotPasswordEvent extends AuthenticationEvent {
  final String phoneNumber;
  AuthenticationResendOTPForgotPasswordEvent({
    required this.phoneNumber,
  });
}

class AuthenticationVerifyOTPForgotPasswordEvent extends AuthenticationEvent {
  final String otp;
  final String phoneNumber;
  AuthenticationVerifyOTPForgotPasswordEvent({
    required this.otp,
    required this.phoneNumber,
  });
}

class AuthenticationLogOutEvent extends AuthenticationEvent {}

class AuthenticationLogOutCancelDeviceEvent extends AuthenticationEvent {
  AuthenticationLogOutCancelDeviceEvent();
}

class AuthenticationInitEvent extends AuthenticationEvent {}

class AuthenticationSaveToken extends AuthenticationEvent {
  final String token;
  AuthenticationSaveToken({
    required this.token,
  });
}

class LocalAuthCheckCurrentPasswordEvent extends AuthenticationEvent {
  final String currentPassword;
  final String route;
  LocalAuthCheckCurrentPasswordEvent(
      {required this.currentPassword, required this.route});
}

class LocalAuthCheckCurrentPasswordToSettingBiometricEvent
    extends AuthenticationEvent {
  final String currentPassword;
  final String route;
  LocalAuthCheckCurrentPasswordToSettingBiometricEvent(
      {required this.currentPassword, required this.route});
}

class FirstOpenAppEvent extends AuthenticationEvent {
  final bool isOpenedApp;
  FirstOpenAppEvent({required this.isOpenedApp});
}

class FirstLoginEvent extends AuthenticationEvent {
  final bool firstLogin;
  FirstLoginEvent({required this.firstLogin});
}

class GetFirstOpenAppEvent extends AuthenticationEvent {}

class GetFirstLoginEvent extends AuthenticationEvent {}
