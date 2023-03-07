import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../../configs/languages/localization.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../common_widgets/text_fields/text_field_common.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/layouts/appbar_common.dart';
import '../../designs/sizer_custom/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
    required this.username,
  }) : super(key: key);
  final String username;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? swipeDirection;
  final TextEditingController _edtPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  FocusNode _focusNodeAccount = FocusNode();

  void onChange(String value) {
    setState(() {
      _isValid = (_formKey.currentState?.validate() == true);
    });
  }

  @override
  void initState() {
    super.initState();
    _isValid = (_formKey.currentState?.validate() == true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorsLight.Lv1,
        appBar: MyAppBar(
          StringKey.forgotPassword.tr,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30.px, 0, 15.px),
                      child: Text(
                        StringKey.enterYourPhoneNumberToChangeNewPassword.tr,
                        style: AppTextStyle.textStyle.s16().w400().cN2(),
                      ),
                    ),
                    TextFieldCommon(
                      controller: _edtPhone,
                      focusNode: _focusNodeAccount,
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _isValid = false;
                          } else {
                            _isValid = true;
                          }
                        });
                      },
                      icon: IconButton(
                        onPressed: null,
                        icon: SvgPicture.asset(
                          AppAssetsLinks.ic_phone,
                        ),
                      ),
                      labelText: StringKey.phoneNumber.tr,
                      hinText: StringKey.phoneNumber.tr,
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                enable: _isValid,
                intervalMs: 2000,
                onTap: () {
                  AppBlocs.authenticationBloc.add(
                    AuthenticationGetOtpForgotPasswordEvent(
                      phoneNumber: _edtPhone.text,
                    ),
                  );
                },
                content: StringKey.next.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
