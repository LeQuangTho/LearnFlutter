part of 'pin_code_bloc.dart';

abstract class PinCodeState {}

class PinCodeInitial extends PinCodeState {}

class PinVerificationFailedState extends PinCodeState {
  final int countNumberEnterPinCode;
  PinVerificationFailedState({
    required this.countNumberEnterPinCode,
  });
}

class PinVerificationSuccessState extends PinCodeState {
  final int countNumberEnterPinCode;
  PinVerificationSuccessState({
    required this.countNumberEnterPinCode,
  });
}
