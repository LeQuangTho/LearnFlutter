import 'package:bloc/bloc.dart';
import 'package:bloc_example/app/counter_app.dart';
import 'package:bloc_example/counter_observer.dart';
import 'package:bloc_example/app/timer_app.dart';
import 'package:flutter/widgets.dart';

// void main() {
//   BlocOverrides.runZoned(
//     () => runApp(const CounterApp()),
//     blocObserver: CounterObserver(),
//   );
// }

void main() {
  BlocOverrides.runZoned(
    () => runApp(const TimerApp()),
    blocObserver: CounterObserver(),
  );
}
