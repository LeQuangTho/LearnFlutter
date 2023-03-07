// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:local_auth/local_auth.dart';

import '../../../BLOC/local_auth/local_auth_bloc.dart';

class ButtonBiometric extends StatelessWidget {
  ButtonBiometric({
    Key? key,
    required this.onTap,
    this.onTapBio,
    required this.content,
    this.enable,
    this.remembered,
    this.isBottom,
    this.isRound = false,
    this.isInvisible = false,
    this.isLast = true,
  }) : super(key: key);
  final Function() onTap;
  final Function()? onTapBio;
  final String content;
  final bool? enable;
  final bool? isBottom;
  final bool? remembered;
  bool isLast;
  bool isRound;
  bool isInvisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, 24.px, 0, (isBottom ?? false) ? 54.px : (isLast ? 24.px : 0.px)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              focusColor: isInvisible ? Colors.transparent : ColorsPrimary.Lv1,
              onTap: onTap,
              child: Container(
                height: 48.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isRound ? 24.px : 10.px),
                  color: isInvisible
                      ? Colors.transparent
                      : ((enable ?? true)
                          ? ColorsPrimary.Lv1
                          : ColorsSupport.disable),
                ),
                child: Center(
                  child: Text(
                    content,
                    style: (isInvisible == true)
                        ? AppTextStyle.textStyle.s16().w700().cP5()
                        : ((enable ?? true)
                            ? AppTextStyle.textStyle.s16().w700().cW5()
                            : AppTextStyle.textStyle.s16().w700().cDisable()),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Visibility(
            visible: remembered ?? true,
            child: BlocBuilder<LocalAuthBloc, LocalAuthState>(
              builder: (context, state) {
                if (state is LocalAuthUnAuthenticated ||
                    state is LocalAuthAuthenticated ||
                    state is LocalAuthProcessing) {
                  if ((state.props[0] as List<BiometricType>).isNotEmpty) {
                    final List<BiometricType> types =
                        state.props[0] as List<BiometricType>;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: onTapBio!,
                          child: Container(
                            height: 48.px,
                            width: 48.px,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.px)),
                              color: ColorsPrimary.Lv1,
                            ),
                            child: Center(
                              child: types.first == BiometricType.face ||
                                      types.first == BiometricType.strong
                                  ? SvgPicture.asset(
                                      AppAssetsLinks.ic_biometric_face)
                                  : (types.first == BiometricType.fingerprint ||
                                          types.first == BiometricType.weak
                                      ? SvgPicture.asset(
                                          AppAssetsLinks.ic_biometric_finger)
                                      : SizedBox()),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox();
                } else {
                  return SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
