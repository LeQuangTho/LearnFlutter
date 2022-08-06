part of 'counter_state.dart';

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(counterValue: 0)) {
    on<CounterEvent>((event, emit) async {
      print(event.name);
      handleCountEvent(event);
    });
  }

  handleCountEvent(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield CounterState(counterValue: state.counterValue + 1);
        break;
      case CounterEvent.decrement:
        yield CounterState(counterValue: state.counterValue - 1);
        break;
    }
  }
}
