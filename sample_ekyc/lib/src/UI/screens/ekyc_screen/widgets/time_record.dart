import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../BLOC/timer/timer_bloc.dart';
import '../../../designs/app_themes/app_text_styles.dart';

class TimeRecord extends StatelessWidget {
  const TimeRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) => state is TimerRunning
          ? _TimerText(duration: state.duration)
          : SizedBox.shrink(),
    );
  }
}

class _TimerText extends StatelessWidget {
  const _TimerText({Key? key, required this.duration}) : super(key: key);
  final int duration;

  @override
  Widget build(BuildContext context) {
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: AppTextStyle.textStyle.s12().w400().cN5(),
    );
  }
}
