import 'package:flutter/material.dart';

import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class GuideSteps extends StatelessWidget {
  const GuideSteps({
    Key? key,
    this.textSpan,
    required this.steps,
  }) : super(key: key);
  final String? textSpan;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(top: 12.px),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20.px,
                        height: 20.px,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorsGray.Lv2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${steps.indexOf(e) + 1}',
                            style: AppTextStyle.textStyle.s12().w700().cN5(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 12.px),
                  Expanded(
                    child: e.contains('textSpan')
                        ? Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: e.replaceAll('textSpan', ''),
                                ),
                                TextSpan(
                                  text: textSpan ?? '',
                                  style:
                                      AppTextStyle.textStyle.s16().cN5().w700(),
                                ),
                              ],
                            ),
                            style: AppTextStyle.textStyle.s16().w400().cN5(),
                          )
                        : Text(e,
                            style: AppTextStyle.textStyle.s16().w400().cN5()),
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
