part of 'resend_otp_bloc.dart';

abstract class ResendOtpState {}

class TimeResendOtpInitial extends ResendOtpState {}

class TimerResendRuning extends ResendOtpState {
  final int duration;
  TimerResendRuning({required this.duration});
}

class TimerResendStoped extends ResendOtpState {}
