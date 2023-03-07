import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../base_model/api_response.dart';
import '../../constants/hard_constants.dart';
import '../../constants/http_status_codes.dart';
import '../../extentions/typedef.dart';
import '../../navigations/app_pages.dart';
import '../../navigations/app_routes.dart';
import '../../repositories/local/local_auth_repository.dart';
import '../../repositories/local/user_local_repository.dart';
import '../../repositories/remote/authentication_repository.dart';
import '../../repositories/remote/user_remote_repository.dart';
import '../app_blocs.dart';
import '../local_auth/local_auth_bloc.dart';
import '../timer/resend_otp/resend_otp_bloc.dart';
import '../timer/timer_bloc.dart';
import '../user_remote/models/response/user_infor_response.dart';
import 'models/add_firebase/add_firebase_reponse.dart';
import 'models/create_password/create_password_form2.dart';
import 'models/login/login_result.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  LoginResponseData loginResponseData = LoginResponseData.empty;
  bool isExist = false;
  String cachedUsername = '';
  String cachedPassword = '';
  String cachedName = '';
  bool rememberAccount = false;
  bool isError = false;
  int countRequestPermisson = 0;
  bool openedApp = false;
  String? firstLogin;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationInitEvent>(_onAuthenticationInit);
    on<AuthenticationCheckRememberedAccountEvent>(_onCheckRememberedAccount);
    on<AuthenticationClearRememberedAccountEvent>(_onClearRememberedAccount);
    on<AuthenticationActiveDeviceEvent>(_onActiveDevice);
    on<AuthenticationChangeFirstPasswordEvent>(_onChangeFirstPassword);
    on<AuthenticationGetOTPChangeFirstPassEvent>(_onGetOTPchangeFirstPass);
    on<AuthenticationResendOTPChangeFirstPassEvent>(
        _onResendOTPChangeFirstPass);
    on<AuthenticationGetOTPEvent>(_onGetOtp);
    on<AuthenticationResendOTPEvent>(_onResendOtp);
    on<AuthenticationGetSmartOtpEvent>(_onGetSmartOtp);
    on<AuthenticationVerifySmartOtpEvent>(_onVerifySmartOTP);
    on<AuthenticationChangePasswordAfterLoginEvent>(
        _onChangePasswordAfterLogin);
    on<LocalAuthCheckCurrentPasswordEvent>(_onCheckCurrentPassword);
    on<LocalAuthCheckCurrentPasswordToSettingBiometricEvent>(
        _onCheckCurrentPasswordToSettingBiometric);
    on<AuthenticationLoginEvent>(_onLogin);
    on<AuthenticationResetTempPasswordEvent>(_onResetTempPass);
    on<AuthenticationAddFirebaseTokenEnableLocationEvent>(
        _onAddFirebaseTokenEnableLocation);
    on<AuthenticationAddFirebaseTokenDisableLocationEvent>(
        _onAddFirebaseTokenDisableLocation);
    on<AuthenticationCheckUserExistEvent>(_onCheckUserExist);
    on<FirstOpenAppEvent>(_onFirstOpenApp);
    on<FirstLoginEvent>(_onFirstLogin);
    on<GetFirstOpenAppEvent>(_onGetFirstOpenApp);
    on<GetFirstLoginEvent>(_onGetFirstLogin);
    on<AuthenticationLogOutEvent>(_onLogOut);
    on<AuthenticationLogOutCancelDeviceEvent>(_onLogOutCancelDevice);
    on<AuthenticationGetOtpForgotPasswordEvent>(_onGetOtpForgotPassword);
    on<AuthenticationResendOTPForgotPasswordEvent>(_onResendOTPForgotPassword);
    on<AuthenticationVerifyOTPForgotPasswordEvent>(_onVerifyOTPForgotPassword);
    on<AuthenticationChangePasswordForgotEvent>(_onChangePasswordForgot);
  }

  void _onAuthenticationInit(
    AuthenticationInitEvent event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(AuthenticationInitial());
  }

  void _onCheckRememberedAccount(
    AuthenticationCheckRememberedAccountEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _checkRememberedAccount();
    if (cachedUsername.isNotEmpty) {
      emit(AuthenticationRemembered(
          username: cachedUsername,
          password: cachedPassword,
          remember: true,
          name: cachedName));
    } else {
      emit(AuthenticationInitial());
    }
  }

  void _onClearRememberedAccount(
    AuthenticationClearRememberedAccountEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await clearRememberedAccout();
    emit(AuthenticationInitial());
  }

  void _onActiveDevice(
    AuthenticationActiveDeviceEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.verifyOTPs(otp: event.otp);
    if (res.data == true) {
      final res2 = await _activeDevice(event);
      if (res2) {
        AppNavigator.pushNamedAndRemoveUntil(
          Routes.SMART_OTP,
        );
      } else {
        showToast(ToastType.error, title: "");
      }
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onChangeFirstPassword(
    AuthenticationChangeFirstPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (event.isNewDevice) {
      AppNavigator.pushNamedAndRemoveUntil(Routes.ACTIVE_DEVICE,
          arguments: {"username:": event.userName});
    } else {
      final res = await _changeFirstPassword(event);
      if (res.code == StatusCode.OK) {
        UserLocalRepository().clearRefreshToken();
        UserPrivateRepo().savePassword(
            event.createPasswordForm.newPassword ?? '',
            username: event.userName);
        AppNavigator.pushNamedAndRemoveUntil(
          Routes.SMART_OTP,
        );
        add(AuthenticationCheckRememberedAccountEvent());
      } else {
        showToast(ToastType.error, title: res.message);
      }
    }
  }

  void _onGetOTPchangeFirstPass(
    AuthenticationGetOTPChangeFirstPassEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getOTPchangeFirstPass();
    if (res.code == StatusCode.OK) {
      AppNavigator.push(Routes.VERIFY_OTP_CHANGE_FIRST_PASS, arguments: {
        'userId': event.userId,
        'userName': event.userName,
        'oldPassword': event.createPasswordForm.oldPassword,
        'newPassword': event.createPasswordForm.newPassword,
        'isNewDevice': loginResponseData.isNewDevice!
      });
      AppBlocs.timerBloc.add(StartCountdownSmsOtpTimerEvent());
      AppBlocs.resendBloc.add(StartResendOtpEvent());
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onResendOTPChangeFirstPass(
    AuthenticationResendOTPChangeFirstPassEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getOTPchangeFirstPass();
    if (res.code == StatusCode.OK) {
      AppBlocs.timerBloc.add(StartCountdownSmsOtpTimerEvent());
      AppBlocs.resendBloc.add(StartResendOtpEvent());
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onGetOtp(
    AuthenticationGetOTPEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getOTP();
    if (res.code == StatusCode.OK) {
      AppNavigator.push(Routes.VERIFY_OTP_CHANGE_FIRST_PASS, arguments: {
        'userName': event.userName,
        'isNewDevice': loginResponseData.isNewDevice!
      });
      AppBlocs.timerBloc.add(StartCountdownSmsOtpTimerEvent());
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onResendOtp(
    AuthenticationResendOTPEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getOTP();
    if (res.code == StatusCode.OK) {
      AppBlocs.timerBloc.add(StartCountdownSmsOtpTimerEvent());
      AppBlocs.resendBloc.add(StartResendOtpEvent());
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onGetSmartOtp(
    AuthenticationGetSmartOtpEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getSmartOTP();
    if (res.code == StatusCode.OK) {
      AppBlocs.timerBloc.add(
        StartCountdownSmartOtpTimerEvent(
          maxDuration: 60,
          onTimerFinish: () => AppBlocs.authenticationBloc.add(
            AuthenticationGetSmartOtpEvent(),
          ),
        ),
      );
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onVerifySmartOTP(
    AuthenticationVerifySmartOtpEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res =
        await AuthenticationRepository.verifySmartOTP(otp: event.smartOtp);
    if (res.code == StatusCode.OK) {
      if (event.routeSuccess != null) {
        AppNavigator.replaceWith(event.routeSuccess!, arguments: event.arg);
      }
      event.action?.call();
    } else {
      if (event.routeFail != null) {
        AppNavigator.replaceWith(event.routeFail!, arguments: event.arg);
      }
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onChangePasswordAfterLogin(
    AuthenticationChangePasswordAfterLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.changePassword(
        createPasswordForm: CreatePasswordForm2(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
      otp: event.otp,
    ));
    if (res.code == StatusCode.OK) {
      AppNavigator.replaceWith(Routes.CHANGE_PASS_SUCCESS,
          arguments: {'typeChangePassword': 'afterLogin'});
      add(AuthenticationCheckRememberedAccountEvent());
      AppBlocs.localAuthBloc.add(LocalAuthDisableBiometricNoAuthenEvent(
          username: AppBlocs.authenticationBloc.cachedName));
    } else {
      AppNavigator.push(Routes.CHANGE_PASS_FAIL,
          arguments: {'typeChangePassword': 'afterLogin'});
    }
    ;
  }

  void _onCheckCurrentPassword(
    LocalAuthCheckCurrentPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (await _checkCurrentPassword(event)) {
      AppNavigator.push(event.route);
      emit(LocalAuthCheckCurrentPasswordSuccess());
    } else {
      emit(LocalAuthCheckCurrentPasswordFail());
      showToast(ToastType.warning, title: 'Mật khẩu không chính xác');
    }
  }

  void _onCheckCurrentPasswordToSettingBiometric(
    LocalAuthCheckCurrentPasswordToSettingBiometricEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (await _checkCurrentPasswordToSettingBiometric(event)) {
      AppNavigator.popUntil(event.route);

      AppBlocs.localAuthBloc.add(LocalAuthActiveBiometricEvent(
          username: AppBlocs.authenticationBloc.cachedUsername,
          password: AppBlocs.authenticationBloc.cachedPassword));
      showToast(ToastType.success,
          title: "Thiết lập đăng nhập bằng" +
              ((AppBlocs.localAuthBloc.biometricTypes.isNotEmpty &&
                      AppBlocs.localAuthBloc.biometricTypes
                          .contains(BiometricType.face))
                  ? "Face ID"
                  : "Touch ID") +
              " thành công");
    } else {
      emit(LocalAuthCheckCurrentPasswordFail());
      showToast(ToastType.warning, title: 'Mật khẩu không chính xác');
    }
  }

  void _onLogin(
    AuthenticationLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(_inProgress);
    loginResponseData = LoginResponseData.empty;
    bool result = await _login(event);
    if (result) {
      if (loginResponseData != LoginResponseData.empty) {
        if (loginResponseData.userModel?.isLock ?? true) {
          showToast(ToastType.error,
              title: "Tài khoản đang bị khoá. Vui lòng liên hệ tổng đài.");
        } else {
          if (loginResponseData.userModel?.isRequiredChangePassword ?? false) {
            DateTime startTime = DateTime.now();
            DateTime expiresTime = DateFormat("MM/dd/yyyy hh:mm:ss").parse(
                AppBlocs.authenticationBloc.loginResponseData.userModel!
                    .tempPasswordDuration!);
            if (startTime.compareTo(expiresTime) > 0) {
              showDialogConfirm(
                  title: "Mật khẩu hết hiệu lực",
                  body:
                      "Mật khẩu tạm thời đã hết hiệu lực. Vui lòng chọn cấp lại mật khẩu tạm thời",
                  textConfirm: "Cấp lại",
                  textClose: "Hủy bỏ",
                  action: () async {
                    await _resetTempPassword(
                        event.username, loginResponseData.accessToken ?? '');
                  });
            } else {
              AppNavigator.push(Routes.CREATE_PASSWORD, arguments: {
                "userName": event.username,
                "passWord": event.password,
                // "registerToken": loginResponseData.accessToken,
              });
            }
          } else {
            if (loginResponseData.isNewDevice!) {
              /// thiết lập thiết bị định danh
              AppNavigator.pushNamedAndRemoveUntil(Routes.ACTIVE_DEVICE,
                  arguments: {"username": event.username});
            } else {
              if (await _isEmptyPinCode()) {
                AppNavigator.pushNamedAndRemoveUntil(Routes.SMART_OTP);
              } else {
                AppNavigator.replaceWith(Routes.HOME);
              }
            }
          }
        }
        await Future.delayed(DELAY_250_MS * 2);
        emit(_success);
      } else {
        AppNavigator.pop();
        add(AuthenticationCheckRememberedAccountEvent());
      }
    } else {
      AppNavigator.pop();
    }
  }

  void _onResetTempPass(
    AuthenticationResetTempPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(_inProgress);
    _resetTempPassword(event.phoneNumber, loginResponseData.accessToken ?? '');
    emit(_success);
  }

  void _onAddFirebaseTokenEnableLocation(
    AuthenticationAddFirebaseTokenEnableLocationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(_inProgress);
    _addFirebaseTokenEnableLocation(loginResponseData.accessToken ?? '');
    emit(_success);
  }

  void _onAddFirebaseTokenDisableLocation(
    AuthenticationAddFirebaseTokenDisableLocationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(_inProgress);
    _addFirebaseTokenDisableLocation(loginResponseData.accessToken ?? '');
    emit(_success);
  }

  void _onCheckUserExist(
    AuthenticationCheckUserExistEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(_inProgress);
    isExist = await _checkUserExist(event.username);
    if (isExist) {
      AppNavigator.push(
        Routes.VERIFY_OTP_CHANGE_FIRST_PASS,
        arguments: {
          'userName': event.username,
          'userId': '',
        },
      );
      await Future.delayed(DELAY_250_MS * 2);
      emit(_success);
    } else {
      showToast(ToastType.error, title: "Tài khoản không tồn tại");
    }
  }

  void _onFirstOpenApp(
    FirstOpenAppEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await UserPrivateRepo().saveAppOpened(event.isOpenedApp);
    openedApp = event.isOpenedApp;
  }

  void _onFirstLogin(
    FirstLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await UserPrivateRepo().saveAppLoginFirst(event.firstLogin);
    firstLogin = event.firstLogin.toString();
  }

  void _onGetFirstOpenApp(
    GetFirstOpenAppEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    openedApp = await UserPrivateRepo().getCheckAppOpened();
  }

  void _onGetFirstLogin(
    GetFirstLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    firstLogin = await UserPrivateRepo().getCheckLoginFirst();
  }

  void _onLogOut(
    AuthenticationLogOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (await _logOut() == true) {
      AppBlocs.logOut();
      if (rememberAccount == true) {
        AppBlocs.localAuthBloc.add(LocalAuthCleanCachedDataEvent());
        emit(_remembered);
      } else {
        emit(AuthenticationInitial());
      }
      AppNavigator.replaceWith(Routes.LOGIN);
    }
  }

  void _onLogOutCancelDevice(
    AuthenticationLogOutCancelDeviceEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (await _logOut() == true) {
      AppBlocs.logOut();
      AppBlocs.localAuthBloc.add(LocalAuthDisableBiometricNoAuthenEvent(
          username: AppBlocs.authenticationBloc.cachedName));
      AppBlocs.localAuthBloc.add(LocalAuthCleanCachedDataEvent());
      add(AuthenticationClearRememberedAccountEvent());
      if (rememberAccount == true) {
        emit(_remembered);
      } else {
        emit(AuthenticationInitial());
      }
      AppNavigator.replaceWith(Routes.LOGIN);
    }
  }

  void _onGetOtpForgotPassword(
    AuthenticationGetOtpForgotPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getOTPForgotPass(
      phoneNumber: event.phoneNumber,
    );
    if (res.code == StatusCode.OK) {
      AppNavigator.push(Routes.VERIFY_OTP_FORGOT_PASS, arguments: {
        'phoneNumber': event.phoneNumber,
      });
      AppBlocs.timerBloc.add(StartCountdownSmsOtpTimerEvent());
      AppBlocs.resendBloc.add(StartResendOtpEvent());
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onResendOTPForgotPassword(
    AuthenticationResendOTPForgotPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.getOTPForgotPass(
        phoneNumber: event.phoneNumber);
    if (res.code == StatusCode.OK) {
      AppBlocs.timerBloc.add(StartCountdownSmsOtpTimerEvent());
      AppBlocs.resendBloc.add(StartResendOtpEvent());
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onVerifyOTPForgotPassword(
    AuthenticationVerifyOTPForgotPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.verifyOTPForgotPass(
        otp: event.otp, phoneNumber: event.phoneNumber);
    if (res.data == true) {
      AppNavigator.push(Routes.CHANGE_PASS_FORGOT, arguments: {
        'phoneNumber': event.phoneNumber,
        'otp': event.otp,
      });
    } else {
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onChangePasswordForgot(
    AuthenticationChangePasswordForgotEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final res = await AuthenticationRepository.changePassForgotPass(
      otp: event.otp,
      phoneNumber: event.phoneNumber,
      newPassword: event.newPassword,
    );
    if (res.data == true) {
      AppBlocs.localAuthBloc.add(LocalAuthDisableBiometricNoAuthenEvent(
          username: AppBlocs.authenticationBloc.cachedName));
      AppNavigator.push(Routes.CHANGE_PASS_SUCCESS);
    } else {
      AppNavigator.push(Routes.CHANGE_PASS_FAIL);
      showToast(ToastType.error, title: res.message);
    }
  }

//* ---------------------------------------------------------------------------------------------------

  AuthenticationInprogress get _inProgress => AuthenticationInprogress(
      username: cachedUsername,
      password: cachedPassword,
      remember: true,
      name: cachedName);

  AuthenticationSuccess get _success => AuthenticationSuccess(
      username: cachedUsername,
      password: cachedPassword,
      remember: true,
      name: cachedName);

  AuthenticationRemembered get _remembered => AuthenticationRemembered(
      username: cachedUsername,
      password: cachedPassword,
      remember: true,
      name: cachedName);

  Future<void> _checkRememberedAccount() async {
    final UserLocalRepository _userLocalRepository = UserLocalRepository();
    final String? _rememberAccount =
        await _userLocalRepository.getRemmemberAccount();
    rememberAccount = (_rememberAccount == true.toString());
    if (rememberAccount) {
      final String? _username = await UserPrivateRepo().getUsername();
      final String? _password =
          await UserPrivateRepo().getPassword(username: _username.toString());
      final String? _name =
          await UserLocalRepository().getName(username: _username.toString());
      cachedUsername = _username ?? '';
      cachedPassword = _password ?? '';
      cachedName = (_name ?? '').toUpperCase();

      print('CHECK username' + cachedUsername);
      print('CHECK password' + cachedPassword);
      print('CHECK name' + cachedName);
    }
  }

  Future<ApiResponse<bool>> _changeFirstPassword(
      AuthenticationChangeFirstPasswordEvent event) async {
    final _result = await AuthenticationRepository.changeFirstPassword(
        createPasswordForm: event.createPasswordForm);
    return _result;
  }

  Future<bool> _activeDevice(AuthenticationActiveDeviceEvent event) async {
    Map<dynamic, dynamic> deviceInfo =
        await UserLocalRepository().getDeviceInfor();
    final _result = await AuthenticationRepository.activeDevice(
        deviceId: deviceInfo['device_id'], deviceName: deviceInfo['name']);
    return _result;
  }

  Future<bool> _checkCurrentPassword(
      LocalAuthCheckCurrentPasswordEvent event) async {
    final bool _result = await AuthenticationRepository.checkCurrentPassword(
        event.currentPassword);
    return _result;
  }

  Future<bool> _checkCurrentPasswordToSettingBiometric(
      LocalAuthCheckCurrentPasswordToSettingBiometricEvent event) async {
    final bool _result = await AuthenticationRepository.checkCurrentPassword(
        event.currentPassword);
    return _result;
  }

  Future<bool> _login(AuthenticationLoginEvent event) async {
    showDialogLoading();
    final LoginResponse? _result = await AuthenticationRepository.login(
      username: event.username,
      password: event.password,
      remember: event.remember,
    );

    if (_result != null) {
      if (_result.code == 200) {
        loginResponseData = _result.data!;
        firstLogin = await UserPrivateRepo().getCheckLoginFirst();
        if (firstLogin == null || firstLogin == 'null') {
          await UserPrivateRepo().saveAppLoginFirst(true);
        } else {
          await UserPrivateRepo().saveAppLoginFirst(false);
        }
        firstLogin = await UserPrivateRepo().getCheckLoginFirst();
        UserLocalRepository().saveAccessToken(_result.data?.accessToken ?? '');
        UserLocalRepository().saveRefreshToken(_result.data?.accessToken ?? '');
        await _getUserInfor();
        rememberAccount = event.remember;
        if (rememberAccount) {
          await UserPrivateRepo().saveUsername(event.username);

          await UserPrivateRepo()
              .savePassword(event.password, username: event.username);
          UserLocalRepository().saveRemmember(event.remember.toString());
          cachedUsername = event.username;
          cachedPassword = event.password;
        } else {
          await UserPrivateRepo().clearUsername();
          await UserPrivateRepo().clearPassword(username: event.username);
          UserLocalRepository().clearRemmember();
        }
        AppNavigator.pop();
        return true;
      } else if (_result.code == 400) {
        AppNavigator.pop();
        Future.delayed(DELAY_500_MS, () {
          showDialogConfirm(
              title: "Đăng nhập không thành công",
              body:
                  "Tên đăng nhập hoặc mật khẩu không đúng. Tài khoản của Bạn sẽ bị khóa nếu nhập sai 5 lần!",
              textConfirm: "Quên mật khẩu",
              textClose: "Thử lại",
              action: () async {
                AppNavigator.push(
                  Routes.FORGOT_PASSWORD,
                  arguments: {'username': event.username},
                );
              });
        });
        return false;
      } else if (_result.code == 403) {
        AppNavigator.pop();
        Future.delayed(DELAY_500_MS, () {
          showDialogLockAccount();
        });
        return false;
      }
      AppNavigator.pop();
      return true;
    } else {
      isError = true;
      Future.delayed(DELAY_500_MS, () {
        showToast(ToastType.error, title: "Sai tài khoản hoặc mật khẩu");
      });
      return false;
    }
  }

  Future<bool> _checkUserExist(String userId) async {
    final bool? _result =
        await AuthenticationRepository.checkUserExist(phone: userId);
    if (_result!) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _resetTempPassword(
      String phoneNumber, String accessToken) async {
    showDialogLoading();
    final bool? _result = await AuthenticationRepository.resetTempPassword(
        phone: phoneNumber, accessToken: accessToken);
    if (_result!) {
      AppNavigator.pop();
      AppNavigator.pop();
      showToast(ToastType.success,
          title:
              "Mật khẩu tạm thời đã được gửi tới SĐT của bạn ${phoneNumber.replaceAll(RegExp(r'\d(?!\d{0,2}$)'), '*')}");
      return true;
    } else {
      AppNavigator.pop();
      showToast(ToastType.error, title: "Cấp lại mật khẩu tạm thời thất bại");
      return false;
    }
  }

  Future<bool> _addFirebaseTokenEnableLocation(String accessToken) async {
    final AddFirebaseReponse? _result =
        await AuthenticationRepository.addFirebaseTokenEnableLocation(
            accessToken);
    if (_result != null && _result.code == StatusCode.OK) {
      return true;
    } else {
      // Future.delayed(DELAY_100_MS, () {
      //   showToast(ToastType.error);
      // });
      return false;
    }
  }

  Future<bool> _addFirebaseTokenDisableLocation(String accessToken) async {
    final AddFirebaseReponse? _result =
        await AuthenticationRepository.addFirebaseTokenDisableLocation(
            accessToken);
    if (_result != null && _result.code == StatusCode.OK) {
      return true;
    } else {
      // Future.delayed(DELAY_100_MS, () {
      //   showToast(ToastType.error);
      // });
      return false;
    }
  }

  Future<bool?> _logOut() async {
    showDialogLoading();
    final String _refreshToken = await UserLocalRepository().getAccessToken();
    final bool _result =
        await AuthenticationRepository.logOut(refreshToken: _refreshToken);
    if (_result) {
      UserLocalRepository().clearAccessToken();
      UserLocalRepository().clearRefreshToken();
      add(AuthenticationCheckRememberedAccountEvent());
    }
    AppNavigator.pop();
    return _result;
  }

  Future<bool?> _logOutCancelDevice() async {
    showDialogLoading();
    final String _refreshToken = await UserLocalRepository().getAccessToken();
    final bool _result =
        await AuthenticationRepository.logOut(refreshToken: _refreshToken);
    AppNavigator.pop();
    return _result;
  }

  Future<void> clearRememberedAccout() async {
    final String? _username = await UserPrivateRepo().getUsername();
    UserPrivateRepo().clearPassword(username: _username ?? '');
    UserPrivateRepo().clearUsername();
    cachedUsername = '';
    cachedPassword = '';
    cachedName = '';
    rememberAccount = false;
    Future.delayed(DELAY_250_MS, () {
      add(AuthenticationCheckRememberedAccountEvent());
    });
  }

  Future<bool> _isEmptyPinCode() async {
    final String? _userId =
        await AppBlocs.userRemoteBloc.userResponseDataEntry.id;
    final String? _pin = await UserPrivateRepo().getPIN(userId: _userId);
    return _pin?.isEmpty ?? true;
  }

  Future<void> _getUserInfor() async {
    final UserInforResponse? response = await UserRemoteRepo.getUserProfile();
    if (response?.data != null) {
      AppBlocs.userRemoteBloc.userResponseDataEntry = response!.data!;
      if (AppBlocs.authenticationBloc.rememberAccount == true) {
        UserLocalRepository().saveName(
            username: AppBlocs.authenticationBloc.cachedUsername,
            name: (AppBlocs.userRemoteBloc.userResponseDataEntry.name ?? ''));
      }
    }
  }
}
