part of 'timer_bloc.dart';

@immutable
abstract class TimerState {}

class TimerInitial extends TimerState {}

class TimerRunning extends TimerState {
  final int duration;
  final int maxDuration;
  TimerRunning({
    required this.duration,
    this.maxDuration = 0,
  });
}

class TimerStoped extends TimerState {}
