part of 'resend_otp_bloc.dart';

abstract class ResendOtpEvent {}

class StartResendOtpEvent extends ResendOtpEvent {}

class StopedResendOtpEvent extends ResendOtpEvent {}

class TimerTickedEvent extends ResendOtpEvent {
  final int duration;

  TimerTickedEvent({required this.duration});
}
