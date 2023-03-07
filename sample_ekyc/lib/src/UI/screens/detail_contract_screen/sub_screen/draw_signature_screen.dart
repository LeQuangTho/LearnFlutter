import 'dart:convert';
import 'dart:ui' as ui;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/BLOC/pin_code_bloc/pin_code_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/models/response/digital_certificate_response.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/user_remote_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/helpers/untils/validator_untils.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';

import '../../../../navigations/app_routes.dart';
import '../../../../repositories/local/user_local_repository.dart';
import '../../../common_widgets/gender_icon/gender_icon.dart';

class DrawSignatureScreen extends StatefulWidget {
  const DrawSignatureScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawSignatureScreen> createState() => _DrawSignatureScreenState();
}

class _DrawSignatureScreenState extends State<DrawSignatureScreen> {
  final _sign = GlobalKey<SignatureState>();

  List<String> listSignature = [];

  String selectSignature = '';

  bool isSignNature = false;

  Map<String, dynamic>? mapAgr;

  String encoded = '';
  int _point = 0;
  // ByteData _img = ByteData(0);
  Future<void> saveSign() async {
    final sign = _sign.currentState;
    final image = await sign?.getData();
    var data = await image?.toByteData(format: ui.ImageByteFormat.png);
    sign?.clear();
    encoded = base64.encode(data!.buffer.asUint8List());
    setState(() {
      // _img = data;
    });
  }

  Future<void> convertSignToBase64() async {
    final sign = _sign.currentState;
    final image = await sign?.getData();
    var data = await image?.toByteData(format: ui.ImageByteFormat.png);
    encoded = base64.encode(data!.buffer.asUint8List());
    setState(() {});
  }

  void clearSign() async {
    final sign = _sign.currentState;
    sign?.clear();
    setState(() {
      // _img = ByteData(0);
      _point = 0;
    });
  }

  DigitalCertificate? cts;

  Future getListSignature() async {
    listSignature = await UserLocalRepository().getListSignature();
    print("lenthhhhh ${listSignature.length}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc
        .add(UserRemoteGetListDigitalCertificateEvent(status: true));
    AppBlocs.ekycBloc.isManageCTS = false;
    getListSignature();
  }

  Future onClick() async {
    mapAgr = await AppNavigator.push(Routes.CHANGE_SIGN_TYPE,
        arguments: {'isSignNature': isSignNature, 'cts': cts});
    if (mapAgr != null) {
      isSignNature = mapAgr?['isSignNature'];
      if (mapAgr?['cts'] != null) cts = mapAgr?['cts'] as DigitalCertificate;
    }
    setState(() {});
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
      appBar: MyAppBar('Ký Hợp Đồng'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 20.px),
                  //   height: 76.px,
                  //   color: ColorsSupport.bannerColor,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Hình thức ký',
                  //         style: AppTextStyle.textStyle.s12().w400().cN2(),
                  //       ),
                  //       SizedBox(height: 4.px),
                  //       Text(
                  //         'Ký bằng chữ ký số',
                  //         style: AppTextStyle.textStyle.s12().w400().cW5(),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 1.px,
                  // ),
                  isSignNature
                      ? Container(
                          color: ColorsWhite.Lv1,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.px, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Chữ ký điện tử an toàn",
                                  style:
                                      AppTextStyle.textStyle.s16().w500().cN5(),
                                ),
                              ),
                              ButtonPrimary(
                                  height: 42.px,
                                  padding: EdgeInsets.zero,
                                  onTap: () async {
                                    onClick();
                                  },
                                  content: "  Thay đổi  ")
                            ],
                          ),
                        )
                      : BlocBuilder<UserRemoteBloc, UserRemoteState>(
                          builder: (context, state) {
                            if (state is UserRemoteGetDoneData) {
                              if (state.digitalCertificates.isNotEmpty) {
                                if (cts == null)
                                  cts = state.digitalCertificates[0];
                                return Container(
                                  color: ColorsWhite.Lv1,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.px, vertical: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: isSignNature
                                            ? Text(
                                                "Chữ ký điện tử an toàn",
                                                style: AppTextStyle.textStyle
                                                    .s16()
                                                    .w500()
                                                    .cN5(),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'CHỨNG THƯ SỐ',
                                                    style: AppTextStyle
                                                        .textStyle
                                                        .s12()
                                                        .w600()
                                                        .cN4(),
                                                  ),
                                                  SizedBox(height: 4.px),
                                                  Text(
                                                    cts?.name ?? '',
                                                    style: AppTextStyle
                                                        .textStyle
                                                        .s16()
                                                        .w500()
                                                        .cN5(),
                                                  ),
                                                ],
                                              ),
                                      ),
                                      ButtonPrimary(
                                          height: 42.px,
                                          padding: EdgeInsets.zero,
                                          onTap: () async {
                                            onClick();
                                          },
                                          content: "  Thay đổi  ")
                                    ],
                                  ),
                                );
                              }
                              cts = null;
                            }
                            return Container(
                              color: ColorsWhite.Lv1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.px, vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CHỨNG THƯ SỐ',
                                          style: AppTextStyle.textStyle
                                              .s12()
                                              .w600()
                                              .cN4(),
                                        ),
                                        SizedBox(height: 4.px),
                                        Text(
                                          'Chưa đăng ký',
                                          style: AppTextStyle.textStyle
                                              .s16()
                                              .w400()
                                              .cN5(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ButtonPrimary(
                                      height: 42.px,
                                      padding: EdgeInsets.zero,
                                      onTap: () async {
                                        onClick();
                                      },
                                      content: "  Thay đổi  ")
                                ],
                              ),
                            );
                          },
                        ),
                  SizedBox(height: 1.px),

                  Stack(
                    children: [
                      Container(
                        color: ColorsLight.Lv1,
                        padding: EdgeInsets.symmetric(horizontal: 20.px),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.px),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Ký tài liệu',
                                  //   style:
                                  //       AppTextStyle.textStyle.s16().w700().cN5(),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              height: 80.w,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: ColorsGray.Lv1,
                                dashPattern: const <double>[12, 6],
                                radius: Radius.circular(20),
                                child: ClipRRect(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Stack(
                                      children: [
                                        Signature(
                                          color: ColorsNeutral.Lv1,
                                          key: _sign,
                                          onSign: () {
                                            selectSignature = '';
                                            setState(() {
                                              _point = (_sign.currentState
                                                      ?.points.length ??
                                                  0);
                                            });
                                          },
                                        ),
                                        (_point > 0)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await convertSignToBase64();
                                                      await UserLocalRepository()
                                                          .addSignature(
                                                              base64: encoded);
                                                      await getListSignature();
                                                      // listSignature.add(encoded);
                                                      // clearSign();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              11),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: ColorsBlue.Lv5,
                                                      ),
                                                      child: Text(
                                                        'Lưu chữ ký',
                                                        style: AppTextStyle
                                                            .textStyle
                                                            .s12()
                                                            .w600()
                                                            .cN5(),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      clearSign();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              11),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            ColorsPrimary.Lv5,
                                                      ),
                                                      child: Text(
                                                        'Ký lại',
                                                        style: AppTextStyle
                                                            .textStyle
                                                            .s12()
                                                            .w600()
                                                            .cN5(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink(),
                                        (_point == 0)
                                            ? Center(
                                                child: Text(
                                                  'Ký tại đây',
                                                  style: AppTextStyle.textStyle
                                                      .s16()
                                                      .w500()
                                                      .cN1(),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 16.px,
                            // ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(vertical: 16),
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all(
                            //       color: ColorsPrimary.Lv1,
                            //       width: 1,
                            //     ),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Icon(
                            //         Icons.camera_alt_outlined,
                            //         color: ColorsIndigo.Lv4,
                            //       ),
                            //       SizedBox(
                            //         width: 8,
                            //       ),
                            //       Text(
                            //         'Chụp hoặc tải ảnh chữ ký',
                            //         style: AppTextStyle.textStyle.s16().w600().cI1(),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.px),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                      primary: false,
                      itemCount: listSignature.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            selectSignature = listSignature[index];
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorsWhite.Lv1,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenderIcon(
                                  active:
                                      selectSignature == listSignature[index],
                                ),
                                SizedBox(
                                  width: 10.px,
                                ),
                                Container(
                                  width: 40.px,
                                  height: 40.px,
                                  decoration: BoxDecoration(
                                      color: ColorsGray.Lv3,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.memory(
                                      base64Decode(listSignature[index])),
                                ),
                                SizedBox(
                                  width: 10.px,
                                ),
                                Expanded(
                                    child: Text(
                                  "Chữ ký đã lưu ${index + 1}",
                                  style:
                                      AppTextStyle.textStyle.s16().w500().cN5(),
                                )),
                                InkWell(
                                  onTap: () async {
                                    await UserLocalRepository().removeSignature(
                                        value: listSignature[index]);
                                    // listSignature.remove(listSignature[index]);
                                    setState(() {});
                                  },
                                  child: SvgPicture.asset(
                                      AppAssetsLinks.ic_delete),
                                )
                              ],
                            ),
                          ),
                        );
                      },
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
                    print(">>> $isSignNature");
                    if (isSignNature == false) {
                      print(">>> $cts");
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
                    await saveSign();
                    AppBlocs.userRemoteBloc.add(UserRemoteSaveBase64Event(
                        selectSignature != '' ? selectSignature : encoded));

                    /// lưu chữ ký dưới dạng base64
                    AppBlocs.pinCodeBloc.add(
                      PinCodeCheckLockEvent(
                          route: Routes.SIGN_CONTRACT_PIN_CODE,
                          arg: {
                            'isSignNature': isSignNature,
                            'idCts': cts?.id,
                          }),

                      /// check validate mã pin
                    );
                  },
                  enable: _point > 0 || selectSignature != '',
                  content: 'Tiếp tục',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
