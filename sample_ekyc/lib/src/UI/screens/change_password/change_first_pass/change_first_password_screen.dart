import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/authentication/authentication_bloc.dart';
import '../../../../BLOC/authentication/models/create_password/create_password_form2.dart';
import '../../../../configs/languages/localization.dart';
import '../../../../constants/hard_constants.dart';
import '../../../../helpers/untils/validator_untils.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/check_box/check_box.dart';
import '../../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../../common_widgets/text_fields/text_field_common.dart';
import '../../../designs/app_background.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';

enum ValidateCondition {
  unknow,
  error,
  valid,
}

class ValidatePassword {
  ValidateCondition validateCondition;
  String error;
  ValidatePassword({
    required this.error,
    required this.validateCondition,
  });
}

class ChangeFirstPasswordScreen extends StatefulWidget {
  const ChangeFirstPasswordScreen({
    Key? key,
    required this.userName,
    required this.password,
  }) : super(key: key);
  final String userName;
  final String password;

  @override
  State<ChangeFirstPasswordScreen> createState() =>
      _ChangeFirstPasswordScreenState();
}

class _ChangeFirstPasswordScreenState extends State<ChangeFirstPasswordScreen> {
  GlobalKey<FormState> _createPasswordKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool _valid = false;
  bool _newPasswordObscureText = true;
  bool _confirmPasswordObscureText = true;
  FocusNode _focusNodePass = FocusNode();
  FocusNode _focusNodePassConfirm = FocusNode();
  // late String _userName;
  // late TextEditingController _userNameController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  List<ValidatePassword> _errorText = [
    ValidatePassword(
        error: StringKey.passwordValidatorLength.tr,
        validateCondition: ValidateCondition.unknow),
    ValidatePassword(
        error: StringKey.passwordValidatorUpper.tr,
        validateCondition: ValidateCondition.unknow),
    ValidatePassword(
        error: StringKey.passwordValidatorLower.tr,
        validateCondition: ValidateCondition.unknow),
    ValidatePassword(
        error: StringKey.passwordValidatorNumberic.tr,
        validateCondition: ValidateCondition.unknow),
    ValidatePassword(
        error: StringKey.passwordValidatorSpecial.tr,
        validateCondition: ValidateCondition.unknow)
  ];

  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    // _userName = widget.userName;
    // _userNameController = TextEditingController(text: _userName);
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _focusNodePassConfirm.addListener(validateCfPass);
    _focusNodePass.addListener(validatePass);

    // AppBlocs.authenticationBloc.add(AuthenticationGetPasswordEvent());
  }

  Widget _buildNewPasswordSurfixIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _newPasswordObscureText = !_newPasswordObscureText;
          });
        },
        icon: _buildSuffixIcon(_newPasswordObscureText));
  }

  Widget _buildSuffixIcon(bool obscureText) {
    return SvgPicture.asset(
      obscureText != true
          ? AppAssetsLinks.ic_eye
          : AppAssetsLinks.ic_eye_disable,
    );
  }

  TextStyle _buildTextStyle(ValidateCondition validateCondition) {
    switch (validateCondition) {
      case ValidateCondition.error:
        return AppTextStyle.textStyle.s12().w400().cR5();
      case ValidateCondition.valid:
        return AppTextStyle.textStyle.s12().w400().cG5();
      default:
        return AppTextStyle.textStyle.s12().w400().cN2();
    }
  }

  void _setValidFields() {
    setState(() {
      _valid = (_createPasswordKey.currentState!.validate() &&
          _setErrorTextCondition() &&
          _confirmPasswordController.text.isNotEmpty);
    });
  }

  bool _setErrorTextCondition() {
    return (_errorText[0].validateCondition == ValidateCondition.valid &&
        _errorText[1].validateCondition == ValidateCondition.valid &&
        _errorText[2].validateCondition == ValidateCondition.valid &&
        _errorText[3].validateCondition == ValidateCondition.valid &&
        _errorText[4].validateCondition == ValidateCondition.valid);
  }

  Icon _buildIcon(ValidateCondition validateCondition) {
    switch (validateCondition) {
      case ValidateCondition.error:
        return Icon(
          Icons.close,
          size: 10,
          color: ColorsRed.Lv1,
        );
      case ValidateCondition.valid:
        return Icon(
          Icons.check,
          size: 10,
          color: ColorsSuccess.Lv1,
        );
      default:
        return Icon(
          Icons.circle_outlined,
          size: 10,
          color: ColorsNeutral.Lv3,
        );
    }
  }

  void _setErrorText(String password, bool active) {
    setState(() {
      if (active) {
        if (ValidatorUtils.isPasswordLengthValidated(password)) {
          _errorText[0].validateCondition = ValidateCondition.valid;
        } else {
          _errorText[0].validateCondition = ValidateCondition.error;
        }
        if (ValidatorUtils.isPasswordContainAnUperCase(password)) {
          _errorText[1].validateCondition = ValidateCondition.valid;
        } else {
          _errorText[1].validateCondition = ValidateCondition.error;
        }
        if (ValidatorUtils.isPasswordContainALowercase(password)) {
          _errorText[2].validateCondition = ValidateCondition.valid;
        } else {
          _errorText[2].validateCondition = ValidateCondition.error;
        }
        if (ValidatorUtils.isPasswordContainANumberic(password)) {
          _errorText[3].validateCondition = ValidateCondition.valid;
        } else {
          _errorText[3].validateCondition = ValidateCondition.error;
        }
        if (ValidatorUtils.isPasswordContainASpecialCharacter(password)) {
          _errorText[4].validateCondition = ValidateCondition.valid;
        } else {
          _errorText[4].validateCondition = ValidateCondition.error;
        }
      }
      _setValidFields();
    });
  }

  void _scrollToTheEnd() {
    Future.delayed(DELAY_500_MS, () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: DELAY_250_MS,
        curve: Curves.easeIn,
      );
    });
  }

  Widget _buildConfirmPasswordSurfixIcon() {
    return IconButton(
        onPressed: () {
          setState(() {
            _confirmPasswordObscureText = !_confirmPasswordObscureText;
          });
        },
        icon: _buildSuffixIcon(_confirmPasswordObscureText));
  }

  void onSubmit() {
    final userId = AppBlocs.userRemoteBloc.userResponseDataEntry.id;
    AppBlocs.authenticationBloc.add(
      AuthenticationGetOTPChangeFirstPassEvent(
        userId: userId ?? '',
        userName: widget.userName,
        createPasswordForm: CreatePasswordForm2(
          newPassword: _newPasswordController.text,
          oldPassword: widget.password,
        ),
      ),
    );
  }

  bool isError = false;

  void validateCfPass() {
    if (_confirmPasswordController.text.isNotEmpty &&
        !_focusNodePassConfirm.hasFocus) {
      checkPass();
    }
  }

  void validatePass() {
    if (_confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        !_focusNodePass.hasFocus) {
      checkPass();
    }
  }

  void checkPass() {
    setState(() {
      if (_confirmPasswordController.text == _newPasswordController.text) {
        isError = false;
      } else {
        isError = true;
        showToast(ToastType.warning,
            title: 'Mật khẩu nhập lại không chính xác');
      }
    });
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BackgroundStack(
        child: Scaffold(
          appBar: MyAppBar(StringKey.changePassword.tr),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: Form(
                      key: _createPasswordKey,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 24.px, 0, 16.px),
                              child: Text(
                                "Thiết lập mật khẩu mới của bạn",
                                style:
                                    AppTextStyle.textStyle.s16().cN5().w500(),
                              ),
                            ),
                            SizedBox(
                              height: 175.px,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 45.px,
                                    left: 0,
                                    right: 0,
                                    bottom: 0.px,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorsGray.Lv2,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.px),
                                          bottomRight: Radius.circular(10.px),
                                        ), // BorderRadius
                                      ), // BoxDecoration
                                      child: Container(
                                        padding: EdgeInsets.only(top: 20.px),
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 1, end: 1, bottom: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.px),
                                            bottomRight: Radius.circular(10.px),
                                          ), // BorderRadius
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildPasswordValidationText(
                                                'Mật khẩu có 8 ký tự trở lên',
                                                _errorText[0]
                                                    .validateCondition),
                                            SizedBox(height: 6.px),
                                            _buildPasswordValidationText(
                                                'Có tối thiểu 1 ký tự in hoa (A, B, C,...)',
                                                _errorText[1]
                                                    .validateCondition),
                                            SizedBox(height: 6.px),
                                            _buildPasswordValidationText(
                                                'Có tối thiểu 1 ký tự in thường (a, b, c,...)',
                                                _errorText[2]
                                                    .validateCondition),
                                            SizedBox(height: 6.px),
                                            _buildPasswordValidationText(
                                                'Có tối thiểu 1 chữ số (0, 1, 2,...)',
                                                _errorText[3]
                                                    .validateCondition),
                                            SizedBox(height: 6.px),
                                            _buildPasswordValidationText(
                                                'Có tối thiểu 1 ký tự đặc biệt (!, @, #,...)',
                                                _errorText[4]
                                                    .validateCondition),
                                          ],
                                        ), // BoxDecoration
                                      ), // Container
                                    ),
                                  ),
                                  TextFieldCommon(
                                    obscureText: _newPasswordObscureText,
                                    suffixIcon: _buildNewPasswordSurfixIcon(),
                                    onTap: _scrollToTheEnd,
                                    onChanged: (password) {
                                      _setErrorText(password, true);
                                    },
                                    icon: IconButton(
                                        onPressed: null,
                                        icon: SvgPicture.asset(
                                          AppAssetsLinks.ic_key,
                                        )),
                                    labelText: StringKey.newPassword.tr,
                                    hinText:
                                        StringKey.passwordLoginFieldHintext.tr,
                                    focusNode: _focusNodePass,
                                    controller: _newPasswordController,
                                    enableBorderColor:
                                        _setErrorTextCondition == false
                                            ? ColorsRed.Lv1
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.px,
                            ),
                            TextFieldCommon(
                              isError: isError,
                              obscureText: _confirmPasswordObscureText,
                              icon: IconButton(
                                  onPressed: null,
                                  icon:
                                      SvgPicture.asset(AppAssetsLinks.ic_key)),
                              focusNode: _focusNodePassConfirm,
                              suffixIcon: _buildConfirmPasswordSurfixIcon(),
                              onTap: _scrollToTheEnd,
                              onChanged: (confirmPassword) {
                                _scrollToTheEnd();
                                _setErrorText(confirmPassword, false);
                              },
                              labelText: StringKey.confirmPassword.tr,
                              hinText: StringKey.passwordLoginFieldHintext.tr,
                              controller: _confirmPasswordController,
                            ),
                            SizedBox(height: 16.px),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.px),
                  decoration: BoxDecoration(
                      color: isChecked ? ColorsSuccess.Lv5 : null,
                      borderRadius: BorderRadius.circular(6.px)),
                  child: Row(
                    children: [
                      CheckBoxCustom(
                          onPress: (value) {
                            isChecked = !isChecked;
                            setState(() {});
                          },
                          isChecked: isChecked),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Tôi đã đọc và đồng ý các ",
                            style: AppTextStyle.textStyle.s14().cN5().w400(),
                            children: [
                              TextSpan(
                                text: "điều khoản và điều kiện chung",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    AppNavigator.push(Routes.ASSETS_PDF_VIEW,
                                        arguments: {
                                          'assetsFilePath': TERMS_AND_CONDITIONS
                                        });
                                  },
                                style: AppTextStyle.textStyle
                                    .s14()
                                    .cN5()
                                    .w700()
                                    .underline(),
                              ),
                              TextSpan(
                                text: " của dịch vụ.",
                                style:
                                    AppTextStyle.textStyle.s14().cN5().w400(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ButtonPrimary(
                  enable: _valid &&
                      _confirmPasswordController.text ==
                          _newPasswordController.text &&
                      isChecked,
                  padding: EdgeInsets.only(top: 8.px, bottom: 24.px),
                  onTap: onSubmit,
                  content: 'Thay đổi mật khẩu',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildPasswordValidationText(
      String content, ValidateCondition condition) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Center(
            child: _buildIcon(condition),
          ),
        ),
        Flexible(
          child: Text(
            content,
            style: _buildTextStyle(condition),
          ),
        ),
      ],
    );
  }
}
