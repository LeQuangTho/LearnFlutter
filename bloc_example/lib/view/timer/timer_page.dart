import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/ticker/timer_bloc.dart';
import '../../ticker.dart';
import '../../view/timer/timer_view.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(
        ticker: const Ticker(),
      ),
      child: const TimerView(),
    );
  }
}
