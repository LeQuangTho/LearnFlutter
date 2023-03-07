part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent {}

//* Sms Otp Event
class StartCountdownSmsOtpTimerEvent extends TimerEvent {}

class StopCountdownSmsOtpTimerEvent extends TimerEvent {}

//* Smart Otp Event
class StartCountdownSmartOtpTimerEvent extends TimerEvent {
  final Callback onTimerFinish;
  final int maxDuration;
  StartCountdownSmartOtpTimerEvent({
    required this.onTimerFinish,
    required this.maxDuration,
  });
}

class StopCountdownSmartOtpTimerEvent extends TimerEvent {}

//* Record Video Event
class StartTimerRecordVideoEvent extends TimerEvent {
  final Callback stopRecordEvent;
  StartTimerRecordVideoEvent({
    required this.stopRecordEvent,
  });
}

class StopTimerRecordVideoEvent extends TimerEvent {}

//* Timer Ticked Event
class TimerTickedEvent extends TimerEvent {
  final int duration;
  final int maxDuration;
  TimerTickedEvent({required this.duration, this.maxDuration = 0});
}
