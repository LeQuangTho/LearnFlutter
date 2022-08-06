import 'package:bloc/bloc.dart';

part 'counter_bloc.dart';

class CounterState {
  int counterValue;

  CounterState({
    required this.counterValue,
  });
}
