import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../BLOC/timer/resend_otp/resend_otp_bloc.dart';
import '../../../extentions/typedef.dart';
import '../../designs/app_themes/app_text_styles.dart';
import 'safe_button.dart';

class ResendOtpButton extends StatelessWidget {
  const ResendOtpButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResendOtpBloc, ResendOtpState>(
      builder: (context, state) {
        if (state is TimerResendRuning) {
          return Text(
            'Gửi lại mã (${state.duration}s)',
            style: AppTextStyle.textStyle.s16().w400().cN4(),
          );
        } else if (state is TimerResendStoped) {
          return SafeButton(
            intervalMs: 3000,
            onSafeTap: onTap,
            child: Text(
              'Gửi lại mã',
              style: AppTextStyle.textStyle.s16().w700().cP5(),
            ),
          );
        } else {
          return Text(
            'Gửi lại mã',
            style: AppTextStyle.textStyle.s16().w700().cP5(),
          );
        }
      },
    );
  }
}
