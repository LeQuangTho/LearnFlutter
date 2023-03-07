import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/authentication/authentication_bloc.dart';
import '../../../../configs/languages/localization.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/text_fields/text_field_common.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

class CheckPassScreen extends StatefulWidget {
  final Map<String, dynamic>? agruments;
  CheckPassScreen({Key? key, this.agruments}) : super(key: key);

  @override
  State<CheckPassScreen> createState() => _CheckPassScreenState();
}

class _CheckPassScreenState extends State<CheckPassScreen> {
  late final TextEditingController _passCrl;
  bool _passwordObscureText = true;
  bool _valid = false;

  FocusNode _passFocusNode = FocusNode();

  @override
  void initState() {
    _passCrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passCrl.dispose();
    AppBlocs.authenticationBloc.add(AuthenticationInitEvent());
    super.dispose();
  }

  Widget _buildSuffixIcon(bool obscureText) {
    return SvgPicture.asset(
      obscureText != true
          ? AppAssetsLinks.ic_eye
          : AppAssetsLinks.ic_eye_disable,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorsLight.Lv1,
        appBar: MyAppBar('Thay đổi mật khẩu'),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.px, horizontal: 20.px),
                    child: Text(
                      'Hãy nhập lại mật khẩu hiện tại để xác thực rằng bạn là chính chủ',
                      style: AppTextStyle.textStyle.s16().w400().cN5(),
                    ),
                  ),
                  Divider(height: 1),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.px),
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        return TextFieldCommon(
                          isError: state is LocalAuthCheckCurrentPasswordFail,
                          obscureText: _passwordObscureText,
                          icon: IconButton(
                            onPressed: null,
                            icon: SvgPicture.asset(
                              AppAssetsLinks.ic_key,
                            ),
                          ),
                          focusNode: _passFocusNode,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordObscureText = !_passwordObscureText;
                              });
                            },
                            icon: _buildSuffixIcon(_passwordObscureText),
                          ),
                          onChanged: (v) {
                            setState(() {
                              _valid = !_passCrl.text.isEmpty;
                            });
                          },
                          labelText: 'Mật khẩu hiện tại',
                          controller: _passCrl,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: ButtonPrimary(
                onTap: () {
                  AppBlocs.authenticationBloc.add(
                    LocalAuthCheckCurrentPasswordEvent(
                      currentPassword: _passCrl.text,
                      route: Routes.CHANGE_PASSWORD,
                    ),
                  );
                },
                content: StringKey.next.tr,
                enable: _valid,
              ),
            )
          ],
        ),
      ),
    );
  }
}
