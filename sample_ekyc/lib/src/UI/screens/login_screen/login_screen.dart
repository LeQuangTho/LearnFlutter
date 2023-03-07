// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/authentication/authentication_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/local_auth/local_auth_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/splash_layout.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/configs/languages/localization.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../common_widgets/buttons/button_biometric.dart';
import '../../common_widgets/buttons/language_menu_button.dart';
import '../../common_widgets/text_fields/text_field_common.dart';
import '../../designs/app_background.dart';
import '../../designs/app_themes/app_colors.dart';
import 'widgets/login_bottom_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationRemembered ||
            state is AuthenticationInprogress) {
          return LoginBody(
            username: state.props[0] as String,
            password: (AppBlocs.localAuthBloc.state is LocalAuthInitial)
                ? state.props[1] as String
                : '',
            rememberAccount: state.props[2] as bool,
            name: state.props[3] as String,
          );
        }
        return LoginBody();
      },
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({
    Key? key,
    this.username,
    this.password,
    this.rememberAccount,
    this.name,
  }) : super(key: key);
  final String? username;
  final String? password;
  final bool? rememberAccount;
  final String? name;
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late bool _rememberAccount;
  final ScrollController _scrollController = ScrollController();
  late List<Widget> remembered;
  late List<Widget> notRemembered;

  FocusNode _focusNodeAccount = FocusNode();
  FocusNode _focusNodePassword = FocusNode();

  bool _passwordHide = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username ?? '');
    _passwordController = TextEditingController(text: '');
    _rememberAccount = widget.rememberAccount ?? false;
    set();
    AppBlocs.localAuthBloc.add(LocalAuthCheckAccountIsActiveBiometricEvent(
      username: widget.username ?? '',
      password: widget.password ?? '',
    ));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void set() {
    remembered = [
      SizedBox(
        height: 40.px,
      ),
      _buildTextLogin(),
      _buildInfoUser(),
      // _buildRememberedWelcomeText(),
      _buildPasswordTextField(),
      _buildNotMeGroup(),
      _buildLoginButton(),
      LoginBottomBar(),
      // _buildSignupSugestionButton(),
    ];
    notRemembered = [
      SizedBox(
        height: 40.px,
      ),
      _buildTextLogin(),
      _buildTextLogin2(),
      _buildUsernameAndPasswordGroup(),
      _buildLoginButton(),
      LoginBottomBar(),
      // _buildSignupSugestionButton(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundStack(
      backGround: AppAssetsLinks.COLOR_BACKGROUND,
      child: SplashLayout(
        mainAxisAlignment: MainAxisAlignment.center,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildListViewGroup(),
          ],
        ),
      ),
    );
  }

  Expanded _buildListViewGroup() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.px,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (widget.username == null || widget.username == '')
                  ? notRemembered
                  : remembered,
              // children: notRemembered,
            ),
          ),
        ),
      ),
    );
  }

  Container _buildInfoUser() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsGray.Lv3,
        borderRadius: BorderRadius.circular(10.px),
      ),
      margin: EdgeInsets.only(bottom: 8.px, top: 16.px),
      padding: EdgeInsets.all(16.px),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.px),
              child: Container(
                height: 40.px,
                width: 40.px,
                child: ClipOval(
                  child: SvgPicture.asset(
                    AppAssetsLinks.user_info,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              widget.username ?? '',
              style: AppTextStyle.textStyle.s16().w500().cN5(),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Text _buildTextLogin() {
    return Text(
      StringKey.login.tr,
      style: AppTextStyle.textStyle.s30().w700().cN5(),
      textAlign: TextAlign.start,
    );
  }

  Padding _buildTextLogin2() {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.px, top: 8.px),
      child: Text(
        StringKey.loginToUserService.tr,
        style: AppTextStyle.textStyle.s16().w400().cN4(),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildUsernameAndPasswordGroup() {
    return Column(
      children: [
        _buildUsernameTextField(),
        _buildPasswordTextField(),
        Container(child: _buildRememberMeGroup())
      ],
    );
  }

  Padding _buildPasswordTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.px),
      child: TextFieldCommon(
        focusNode: _focusNodePassword,
        icon: IconButton(
            onPressed: null, icon: SvgPicture.asset(AppAssetsLinks.ic_key)),
        labelText: StringKey.passwordLoginFieldHintext.tr,
        hinText: StringKey.passwordLoginFieldHintext.tr,
        controller: _passwordController,
        obscureText: _passwordHide,
        suffixIcon: _buildNewPasswordSurfixIcon(),
      ),
    );
  }

  Container _buildUsernameTextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 8.px),
      child: TextFieldCommon(
        focusNode: _focusNodeAccount,
        textInputType: TextInputType.number,
        icon: IconButton(
          onPressed: null,
          icon: SvgPicture.asset(AppAssetsLinks.ic_phone),
        ),
        labelText: StringKey.accountLoginFieldHintext.tr,
        hinText: StringKey.accountLoginFieldHintext.tr,
        controller: _usernameController,
      ),
    );
  }

  Row _buildRememberMeGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            set();
            setState(() {});
            AppNavigator.push(
              Routes.FORGOT_PASSWORD,
              arguments: {'username': _usernameController.text},
            );
          },
          child: Text(
            StringKey.forgotPassword.tr,
            style: AppTextStyle.textStyle.s16().w500().cN4(),
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }

  Row _buildNotMeGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            _usernameController.text = '';
            _passwordController.text = '';
            AppBlocs.authenticationBloc
                .add(AuthenticationClearRememberedAccountEvent());
            setState(() {
              set();
            });
          },
          child: Text(
            "Đổi tài khoản",
            style: AppTextStyle.textStyle.s14().w600().cN3(),
          ),
        ),
        InkWell(
          onTap: () {
            set();
            setState(() {});
            AppNavigator.push(
              Routes.FORGOT_PASSWORD,
              arguments: {'username': _usernameController.text},
            );
          },
          child: Text(
            StringKey.forgotPassword.tr,
            style: AppTextStyle.textStyle.s14().w400().cN3(),
          ),
        ),
      ],
    );
  }

  Container _buildLanguagePickerDropdownButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.px),
            child: Container(
              height: 48.px,
              child: LanguagePickerButton(),
            ),
          )
        ],
      ),
    );
  }

  _buildLoginButton() {
    return Padding(
      padding: EdgeInsets.only(top: 80.px),
      child: ButtonBiometric(
        enable: true,
        onTapBio: () {
          AppBlocs.localAuthBloc.add(
              LocalAuthBiometricLoginEvent(username: _usernameController.text));
        },
        content: StringKey.login.tr,
        remembered: _rememberAccount,
        onTap: () {
          if (_usernameController.text.isEmpty) {
            showToast(ToastType.warning, title: "Chưa nhập số điện thoại");
          } else if (_passwordController.text.isEmpty) {
            showToast(ToastType.warning, title: "Chưa nhập mật khẩu");
          } else {
            AppBlocs.authenticationBloc.add(
              AuthenticationLoginEvent(
                username: _usernameController.text,
                password: _passwordController.text,
                remember: true,
              ),
            );
          }
        },
      ),
    );
  }

  Padding _buildSignupSugestionButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.px),
      child: Container(
        height: 48.px,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    StringKey.dontHaveAcc.tr,
                    style: AppTextStyle.textStyle.s16().w500().cN3(),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // AppNavigator.push(
                      //   Routes.REGISTER,
                      // );
                    },
                    child: Text(
                      StringKey.signUpNow.tr,
                      style: AppTextStyle.textStyle.s16().w500().cP4(),
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordSurfixIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _passwordHide = !_passwordHide;
            set();
          });
        },
        icon: _buildSuffixIcon(_passwordHide));
  }

  Widget _buildSuffixIcon(bool obscureText) {
    return SvgPicture.asset(
      obscureText != true
          ? AppAssetsLinks.ic_eye
          : AppAssetsLinks.ic_eye_disable,
    );
  }
}
