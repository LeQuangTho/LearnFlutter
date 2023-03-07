import 'package:bloc/bloc.dart';

import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../constants/local_storage_keys.dart';
import '../../helpers/untils/logger.dart';
import '../../navigations/app_pages.dart';
import '../../repositories/local/local_auth_repository.dart';
import '../../repositories/local/user_local_repository.dart';
import '../app_blocs.dart';

part 'pin_code_event.dart';
part 'pin_code_state.dart';

class PinCodeBloc extends Bloc<PinCodeEvent, PinCodeState> {
  PinCodeBloc() : super(PinCodeInitial()) {
    UserLocalRepository()
        .getString(key: LocalStorageKey.TIMES_ENTER_PIN_CODE, defaultValue: '5')
        .then((value) => timesEnterPinCode = int.parse(value));
    on<PinCodeCheckLockEvent>(_onCheckLock);
    on<PinCodeVerifyEvent>(_onVerify);
    on<PinCodeSetPinCodeEvent>(_onSetPinCode);
  }

  int timesEnterPinCode = 5;

  void _onCheckLock(
    PinCodeCheckLockEvent event,
    Emitter<PinCodeState> emit,
  ) async {
    final unLockTime = await UserLocalRepository().getString(
        key: LocalStorageKey.PIN_FEATURE_UNLOCK_TIME,
        defaultValue: DateTime.now().subtract(Duration(days: 100)).toString());
    final bool isValidTime =
        DateTime.now().compareTo(DateTime.parse(unLockTime)) > 0;
    if (isValidTime) {
      UserLocalRepository()
          .clearString(key: LocalStorageKey.PIN_FEATURE_UNLOCK_TIME);
      UserLocalRepository()
          .clearString(key: LocalStorageKey.TIMES_ENTER_PIN_CODE);
      timesEnterPinCode = 5;
      AppNavigator.push(event.route, arguments: event.arg);
      emit(_pinVerificationSuccessState);
    } else {
      if (timesEnterPinCode > 0) {
        AppNavigator.push(event.route, arguments: event.arg);
        emit(_pinVerificationSuccessState);
      } else {
        showToast(ToastType.error,
            title:
                'Tính năng Smart OTP bị tạm khóa trong 5 phút do bạn đã nhập sai mã PIN quá 5 lần liên tiếp. Vui lòng chờ 5 phút để mở khóa hoặc chọn \"Quên mã PIN\"');
        emit(_pinVerificationFailedState);
      }
    }
  }

  void _onVerify(
    PinCodeVerifyEvent event,
    Emitter<PinCodeState> emit,
  ) async {
    if (timesEnterPinCode > 0) {
      final bool result = await _verifyPinCode(pin: event.pinCode);
      if (result) {
        UserLocalRepository()
            .clearString(key: LocalStorageKey.PIN_FEATURE_UNLOCK_TIME);
        UserLocalRepository()
            .clearString(key: LocalStorageKey.TIMES_ENTER_PIN_CODE);
        timesEnterPinCode = 5;
        if (event.route != null) {
          AppNavigator.push(event.route!, arguments: event.arg);
        }
        if (event.action != null) event.action!.call();
        emit(_pinVerificationSuccessState);
      } else {
        timesEnterPinCode--;
        final now = DateTime.now();
        final unlockTime = now.add(Duration(minutes: 5));
        UtilLogger.log('>>>>>>>> now', '$now');
        UtilLogger.log('>>>>>>>> timeOpen', '$unlockTime');
        UserLocalRepository().saveString(
          key: LocalStorageKey.PIN_FEATURE_UNLOCK_TIME,
          value: unlockTime.toString(),
        );
        UserLocalRepository().saveString(
          key: LocalStorageKey.TIMES_ENTER_PIN_CODE,
          value: timesEnterPinCode.toString(),
        );
        showToast(ToastType.error, title: 'Mã PIN không chính xác');
        emit(_pinVerificationFailedState);
      }
    } else {
      showToast(ToastType.error,
          title:
              'Tính năng Smart OTP bị tạm khóa trong 5 phút do bạn đã nhập sai mã PIN quá 5 lần liên tiếp. Vui lòng chờ 5 phút để mở khóa hoặc chọn \"Quên mã PIN\"');
      emit(_pinVerificationFailedState);
    }
  }

  void _onSetPinCode(
    PinCodeSetPinCodeEvent event,
    Emitter<PinCodeState> emit,
  ) async {
    final bool result = await _setPinCode(newPinCode: event.newPinCode);
    if (result) {
      UserLocalRepository()
          .clearString(key: LocalStorageKey.PIN_FEATURE_UNLOCK_TIME);
      UserLocalRepository()
          .clearString(key: LocalStorageKey.TIMES_ENTER_PIN_CODE);
      timesEnterPinCode = 5;
      AppNavigator.push(event.routeSuccess);
    } else {
      if (event.routeFail != null) {
        AppNavigator.push(event.routeFail!);
      }
    }
  }

  PinVerificationFailedState get _pinVerificationFailedState =>
      PinVerificationFailedState(
        countNumberEnterPinCode: timesEnterPinCode,
      );
  PinVerificationSuccessState get _pinVerificationSuccessState =>
      PinVerificationSuccessState(
        countNumberEnterPinCode: timesEnterPinCode,
      );

  Future<String> _getCurrentPinCode(String userId) async {
    final String PIN = await UserPrivateRepo().getPIN(userId: userId) ?? '';
    return PIN;
  }

  Future<bool> _verifyPinCode({required String pin}) async {
    final _userId = AppBlocs.userRemoteBloc.userResponseDataEntry.id ?? '';
    final String currentPIN = await _getCurrentPinCode(_userId);
    return pin == currentPIN;
  }

  Future<bool> _setPinCode({required String newPinCode}) async {
    final _userId = AppBlocs.userRemoteBloc.userResponseDataEntry.id ?? '';
    return await UserPrivateRepo().setPIN(_userId, newPinCode);
  }
}
