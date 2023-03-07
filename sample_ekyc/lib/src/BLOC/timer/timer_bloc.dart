import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../extentions/typedef.dart';
import 'ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerInitial()) {
    on<StartCountdownSmsOtpTimerEvent>(_onStartSmsOtpTimer);
    on<StopCountdownSmsOtpTimerEvent>(_onStopSmsOtpTimer);
    on<StartCountdownSmartOtpTimerEvent>(_onStartSmartOtpTimer);
    on<StopCountdownSmartOtpTimerEvent>(_onStopSmartOtpTimer);
    on<StartTimerRecordVideoEvent>(_onStartRecordVideoTimer);
    on<StopTimerRecordVideoEvent>(_onStopRecordVideoTimer);
    on<TimerTickedEvent>(_onTimerTicked);
  }

  int _maxDurationSmsOtp = 300;
  Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  //* Timer SmsOTP
  void _onStartSmsOtpTimer(
    StartCountdownSmsOtpTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: _maxDurationSmsOtp, tickerType: TickerType.descending)
        .listen((duration) {
      add(TimerTickedEvent(
          duration: duration, maxDuration: _maxDurationSmsOtp));
      if (duration == 0) add(StopCountdownSmsOtpTimerEvent());
    });
  }

  void _onStopSmsOtpTimer(
    StopCountdownSmsOtpTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    emit(TimerStoped());
  }

  //* Timer SmartOTP
  void _onStartSmartOtpTimer(
    StartCountdownSmartOtpTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.maxDuration, tickerType: TickerType.descending)
        .listen((duration) {
      add(TimerTickedEvent(duration: duration, maxDuration: event.maxDuration));
      if (duration == 0) {
        _tickerSubscription?.cancel();
        event.onTimerFinish();
      }
    });
  }

  void _onStopSmartOtpTimer(
    StopCountdownSmartOtpTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    emit(TimerStoped());
  }

  //* Timer Record Video
  void _onStartRecordVideoTimer(
    StartTimerRecordVideoEvent event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: 0, tickerType: TickerType.ascending)
        .listen((duration) {
      add(TimerTickedEvent(duration: duration));
      if (duration == 10) event.stopRecordEvent();
    });
  }

  void _onStopRecordVideoTimer(
    StopTimerRecordVideoEvent event,
    Emitter<TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    emit(TimerStoped());
  }

  //* Emit State
  void _onTimerTicked(
    TimerTickedEvent event,
    Emitter<TimerState> emit,
  ) async {
    emit(
        TimerRunning(duration: event.duration, maxDuration: event.maxDuration));
  }
}
