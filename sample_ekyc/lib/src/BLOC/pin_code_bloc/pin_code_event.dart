part of 'pin_code_bloc.dart';

abstract class PinCodeEvent {}

class PinCodeCheckLockEvent extends PinCodeEvent {
  final String route;
  final Map<String, dynamic>? arg;
  PinCodeCheckLockEvent({
    required this.route,
    this.arg,
  });
}

class PinCodeVerifyEvent extends PinCodeEvent {
  final String pinCode;
  final String? route;
  final Map<String, dynamic>? arg;
  final void Function()? action;
  PinCodeVerifyEvent({
    required this.pinCode,
    this.route,
    this.arg,
    this.action,
  });
}

class PinCodeSetPinCodeEvent extends PinCodeEvent {
  final String newPinCode;
  final String routeSuccess;
  final String? routeFail;
  PinCodeSetPinCodeEvent({
    required this.newPinCode,
    required this.routeSuccess,
    this.routeFail,
  });
}

class PinCodeGetPinCodeEvent extends PinCodeEvent {}
