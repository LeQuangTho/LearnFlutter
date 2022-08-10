import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final Widget child;

  const CounterWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<CounterWidget> createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  void incrementCounter() {
    setState(() {
      count = count + 1;
    });
  }

  void resetCounter() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CountState(
      addCounter: incrementCounter,
      count: count,
      removeCounter: resetCounter,
      child: widget.child,
    );
  }
}

class CountState extends InheritedWidget {
  const CountState({
    required this.count,
    required this.addCounter,
    required this.removeCounter,
    Key? key,
    required super.child,
  }) : super(key: key);

  final int count;
  final Function() addCounter;
  final Function() removeCounter;

  static CountState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CountState>();
  }

  @override
  bool updateShouldNotify(CountState oldWidget) {
    return oldWidget.count != count;
  }
}
