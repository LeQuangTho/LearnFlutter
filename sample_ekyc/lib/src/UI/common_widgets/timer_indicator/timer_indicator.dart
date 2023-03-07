import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../BLOC/timer/timer_bloc.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';

class TimerIndicator extends StatelessWidget {
  const TimerIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.px),
      height: 58.px,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.px), color: ColorsGray.Lv3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state is TimerRunning) {
                return Text(
                  'Mã OTP có hiệu lực trong: ${state.duration}s',
                  style: AppTextStyle.textStyle.s12().w400().cN5(),
                );
              }
              return Text(
                'Mã OTP có hiệu lực trong: 0s',
                style: AppTextStyle.textStyle.s12().w400().cN5(),
              );
            },
          ),
          SizedBox(
            height: 8.px,
          ),
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state is TimerRunning) {
                return Row(
                  children: [
                    Expanded(
                      flex: state.duration,
                      child: Container(
                        height: 2.px,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.px),
                          color: ColorsPrimary.Lv1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: state.maxDuration - state.duration,
                      child: Container(
                        height: 2.px,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.px),
                          color: ColorsWhite.Lv1,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container(
                height: 2.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.px),
                  color: ColorsWhite.Lv1,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
