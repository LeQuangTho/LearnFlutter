import 'dart:async';

import 'package:bloc/bloc.dart';

import '../ticker.dart';

part 'resend_otp_event.dart';
part 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOtpEvent, ResendOtpState> {
  ResendOtpBloc() : super(TimeResendOtpInitial()) {
    on<StartResendOtpEvent>(_onStartResendOtp);
    on<StopedResendOtpEvent>(_onStopedResendOtp);
    on<TimerTickedEvent>(_onTimerTicked);
  }

  int _durResendTimer = 60;
  Ticker _ticker = Ticker();

  StreamSubscription<int>? _tickerSubscription;

  void _onStartResendOtp(
    StartResendOtpEvent event,
    Emitter<ResendOtpState> emit,
  ) async {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: _durResendTimer, tickerType: TickerType.descending)
        .listen((duration) {
      add(TimerTickedEvent(duration: duration));
      if (duration == 0) add(StopedResendOtpEvent());
    });
  }

  void _onStopedResendOtp(
    StopedResendOtpEvent event,
    Emitter<ResendOtpState> emit,
  ) async {
    _tickerSubscription?.cancel();
    emit(TimerResendStoped());
  }

  void _onTimerTicked(
    TimerTickedEvent event,
    Emitter<ResendOtpState> emit,
  ) async {
    emit(TimerResendRuning(duration: event.duration));
  }
}
