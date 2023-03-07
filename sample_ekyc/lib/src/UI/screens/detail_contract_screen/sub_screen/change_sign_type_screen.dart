import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/user_remote_bloc.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';

import '../../../../BLOC/user_remote/models/response/digital_certificate_response.dart';
import '../../../../helpers/untils/validator_untils.dart';
import '../../../common_widgets/buttons/button_pop.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../../common_widgets/gender_icon/gender_icon.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';

class ChangeSignTypeScreen extends StatefulWidget {
  const ChangeSignTypeScreen({Key? key, required this.arg}) : super();
  final Map<String, dynamic>? arg;
  @override
  State<ChangeSignTypeScreen> createState() => _ChangeSignTypeState();
}

class _ChangeSignTypeState extends State<ChangeSignTypeScreen> {
  bool isSignNature = true;

  DigitalCertificate? cts;

  @override
  void initState() {    
    super.initState();
    AppBlocs.userRemoteBloc
        .add(UserRemoteGetListDigitalCertificateEvent(status: true));
    isSignNature = widget.arg?['isSignNature'];
    if (widget.arg?['cts'] != null) {
      cts = widget.arg?['cts'] as DigitalCertificate;
    }
  }

  String getNameCer(String value) {
    String result = value
        .split(',')
        .toList()
        .firstWhere((e) => e.contains('CN='), orElse: () => '')
        .replaceAll('CN=', '');

    return result;
  }

  void registerCTS() {
    if (ValidatorUtils.hasInfoCreateCTS()) {
      AppNavigator.push(Routes.EKYC);
    } else {
      showDialogMissInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsGray.Lv3,
      appBar: MyAppBar('Thay đổi hình thức ký'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: Column(
                children: [
                  SizedBox(
                    height: 25.px,
                  ),
                  BlocBuilder<UserRemoteBloc, UserRemoteState>(
                    builder: (context, state) {
                      if (state is UserRemoteGetDoneData) {
                        if (state.digitalCertificates.isNotEmpty) {
                          return InkWell(
                            onTap: () {
                              isSignNature = false;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorsWhite.Lv1,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.px, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GenderIcon(
                                    active: isSignNature == false,
                                  ),
                                  SizedBox(
                                    width: 10.px,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chứng thư số',
                                          style: AppTextStyle.textStyle
                                              .s14()
                                              .w500()
                                              .cN5(),
                                        ),
                                        SizedBox(height: 5.px),
                                        Text(
                                          cts?.name ?? '',
                                          style: AppTextStyle.textStyle
                                              .s16()
                                              .w400()
                                              .cN4(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.px,
                                  ),
                                  Visibility(
                                    visible: !isSignNature,
                                    child: ButtonPrimary(
                                        height: 42.px,
                                        padding: EdgeInsets.zero,
                                        onTap: () async {
                                          state.digitalCertificates
                                              .where((element) =>
                                                  element.id == cts?.id)
                                              .toList()[0]
                                              .selected = true;
                                          showDialog(
                                            context: AppNavigator.context!,
                                            barrierColor: Colors.transparent,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder:
                                                    (context, setStateDialog) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        ColorsLight.Lv1,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14))),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Chọn chứng thư số",
                                                            style: AppTextStyle
                                                                .textStyle
                                                                .s16()
                                                                .w700()
                                                                .cN5(),
                                                          ),
                                                          SizedBox(
                                                            height: 10.px,
                                                          ),
                                                          ListView.separated(
                                                            shrinkWrap: true,
                                                            primary: false,
                                                            itemCount: state
                                                                .digitalCertificates
                                                                .length,
                                                            separatorBuilder:
                                                                (c, i) =>
                                                                    SizedBox(
                                                                        height:
                                                                            8),
                                                            itemBuilder:
                                                                (c, i) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  state
                                                                      .digitalCertificates
                                                                      .forEach(
                                                                          (element) {
                                                                    element.selected =
                                                                        false;
                                                                  });
                                                                  state
                                                                      .digitalCertificates[
                                                                          i]
                                                                      .selected = true;
                                                                  setStateDialog(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  color:
                                                                      ColorsWhite
                                                                          .Lv1,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.px,
                                                                      vertical:
                                                                          10),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      GenderIcon(
                                                                        active: state
                                                                            .digitalCertificates[i]
                                                                            .selected,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 10
                                                                            .px,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getNameCer(state.digitalCertificates[i].subjectDN ?? ''),
                                                                              style: AppTextStyle.textStyle.s14().w500().cN5(),
                                                                            ),
                                                                            SizedBox(height: 4.px),
                                                                            Text(
                                                                              state.digitalCertificates[i].name ?? '',
                                                                              style: AppTextStyle.textStyle.s16().w400().cN4(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 10.px,
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      ButtonPop2(
                                                                    buttonTitle:
                                                                        'Hủy bỏ',
                                                                    colorButton:
                                                                        ColorsPrimary
                                                                            .Lv5,
                                                                    colorText:
                                                                        ColorsPrimary
                                                                            .Lv1,
                                                                    height:
                                                                        42.px,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        8.px),
                                                                Expanded(
                                                                  child:
                                                                      ButtonPrimary(
                                                                    height:
                                                                        42.px,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    content:
                                                                        'Xác nhận',
                                                                    onTap: () {
                                                                      cts = state
                                                                          .digitalCertificates
                                                                          .where((element) =>
                                                                              element.selected ==
                                                                              true)
                                                                          .toList()[0];
                                                                      setState(
                                                                          () {});
                                                                      AppNavigator
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        content: "   Chọn   "),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      return InkWell(
                        onTap: () {
                          isSignNature = false;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorsWhite.Lv1,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.px, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GenderIcon(
                                active: isSignNature == false,
                              ),
                              SizedBox(
                                width: 10.px,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chứng thư số',
                                      style: AppTextStyle.textStyle
                                          .s14()
                                          .w500()
                                          .cN5(),
                                    ),
                                    SizedBox(height: 4.px),
                                    Text(
                                      'Chưa đăng ký',
                                      style: AppTextStyle.textStyle
                                          .s16()
                                          .w400()
                                          .cN4(),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !isSignNature,
                                child: ButtonPrimary(
                                    height: 42.px,
                                    padding: EdgeInsets.zero,
                                    onTap: () => registerCTS(),
                                    content: "  Đăng ký  "),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.px,
                  ),
                  InkWell(
                    onTap: () {
                      isSignNature = true;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorsWhite.Lv1,
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.px, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GenderIcon(
                            active: isSignNature == true,
                          ),
                          SizedBox(
                            width: 10.px,
                          ),
                          Expanded(
                              child: Text(
                            "Chữ ký điện tử an toàn",
                            style: AppTextStyle.textStyle.s16().w500().cN5(),
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: ColorsLight.Lv1,
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Column(
              children: [
                SizedBox(
                  height: 16.px,
                ),
                ButtonPrimary(
                  onTap: () async {
                    if (isSignNature == false) {
                      if (cts == null) {
                        showDialogConfirm(
                            title: "Thông báo",
                            body:
                                "Bạn chưa có chứng thư số hoặc chứng thư số đã hết hạn. Bấm đăng ký để tạo chứng thư số mới.",
                            textConfirm: "Đăng ký",
                            textClose: "Hủy bỏ",
                            action: () => registerCTS());
                        return null;
                      }
                    }
                    Navigator.pop(
                        context, {"isSignNature": isSignNature, "cts": cts});
                  },
                  content: 'Thay đổi',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
