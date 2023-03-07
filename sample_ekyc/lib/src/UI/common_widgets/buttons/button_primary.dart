// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/authentication/authentication_bloc.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/repositories/local/local_auth_repository.dart';

class ButtonPrimary extends StatelessWidget {
  ButtonPrimary({
    Key? key,
    required this.onTap,
    required this.content,
    this.activeBiometric,
    this.enable,
    this.username,
    this.isInvisible = false,
    this.height,
    this.padding,
    this.intervalMs = 500,
  }) : super(key: key);
  final Function() onTap;
  final String content;
  final String? username;
  final bool? activeBiometric;
  final bool? enable;
  bool isInvisible;
  final double? height;
  final EdgeInsets? padding;
  final int intervalMs;

  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.only(bottom: 42),
      child: InkWell(
        focusColor: isInvisible ? Colors.transparent : ColorsPrimary.Lv2,
        onTap: enable ?? true
            ? () {
                final now = DateTime.now().millisecondsSinceEpoch;
                if (now - lastTimeClicked > intervalMs) {
                  lastTimeClicked = now;
                  onTap();
                }
              }
            : null,
        child: Stack(
          children: [
            Container(
              height: height ?? 56.px,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.px),
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
                      ? AppTextStyle.textStyle.s16().w500().cP5()
                      : ((enable ?? true)
                          ? AppTextStyle.textStyle.s16().w500().cW5()
                          : AppTextStyle.textStyle.s16().w500().cDisable()),
                ),
              ),
            ),
            (activeBiometric == true)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          final BiometricAccount account =
                              await UserPrivateRepo()
                                  .getBiometricAccount(username ?? '');

                          if (account.bioUsername != '' &&
                              account.bioPassword != '') {
                            AppBlocs.authenticationBloc.add(
                              AuthenticationLoginEvent(
                                  username: account.bioUsername ?? '',
                                  password: account.bioPassword ?? '',
                                  remember: false),
                            );
                          }
                        },
                        child: Container(
                          height: 48.px,
                          width: 48.px,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.px),
                            color: ColorsYellow.Y5,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
