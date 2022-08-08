import 'package:bloc/bloc.dart';
import 'package:bloc_example/app/infinite_list_app.dart';
import 'package:bloc_example/counter_observer.dart';
import 'package:flutter/widgets.dart';

// void main() {
//   BlocOverrides.runZoned(
//     () => runApp(const CounterApp()),
//     blocObserver: CounterObserver(),
//   );
// }

// void main() {
//   BlocOverrides.runZoned(
//     () => runApp(const TimerApp()),
//     blocObserver: CounterObserver(),
//   );
// }

void main() {
  BlocOverrides.runZoned(
    () => runApp(const InfiniteListApp()),
    blocObserver: CounterObserver(),
  );
}
