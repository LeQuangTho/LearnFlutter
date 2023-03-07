import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hdsaison_signing/src/UI/screens/detail_contract_screen/sub_screen/refuse_sign.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/user_remote/models/response/contract_detail_response.dart';
import '../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../helpers/geolocator_helper.dart';
import '../../common_widgets/buttons/button_pop.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../common_widgets/check_box/check_box.dart';
import '../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../common_widgets/loading/cover_loading.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/layouts/appbar_common.dart';
import '../../designs/sizer_custom/sizer.dart';
import '../user_profile/sub_screens/user_info_screen.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';

class DetailContractScreen extends StatefulWidget {
  final String idDocument;
  final String nameDocument;

  DetailContractScreen(
      {Key? key, required this.idDocument, required this.nameDocument})
      : super(key: key);

  @override
  State<DetailContractScreen> createState() => _DetailContractScreenState();
}

class _DetailContractScreenState extends State<DetailContractScreen> {
  ContractDetailResponse data = ContractDetailResponse.empty;
  String path = '';

  bool _isCheck1 = false;
  bool _isCheck2 = false;

  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc
        .add(UserRemoteGetDetailContractsEvent(idDocument: widget.idDocument));
  }

  List<Widget> _buildMetaData() {
    var listMetaData = data.data?.listMetaData ?? [];
    listMetaData.removeWhere((element) => element.key == "DOC_ID");
    return listMetaData
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            index == 0
                ? InfoField.first(
                    title: element.key ?? '',
                    content: element.value ?? '',
                  )
                : InfoField(
                    title: element.key ?? '',
                    content: element.value ?? '',
                  ),
          ),
        )
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(widget.nameDocument),
      backgroundColor: ColorsGray.Lv3,
      body: BlocBuilder<UserRemoteBloc, UserRemoteState>(
        builder: (context, state) {
          if (state is UserRemoteGetDoneData) {
            if (state.contractDetailResponse != null) {
              data = state.contractDetailResponse;
            }
            return body(state.contractDetailResponse);
          }
          return body(data);
        },
      ),
    );
  }

  Widget body(ContractDetailResponse data) {
    List list = data.data?.listMetaData
            ?.where((element) =>
                element.key == 'SO_HD' ||
                element.key
                        ?.toLowerCase()
                        .contains('Số hợp đồng'.toLowerCase()) ==
                    true)
            .toList() ??
        [];

    String docName = widget.idDocument != data.data?.documentId
        ? ''
        : list.isNotEmpty
            ? list[0].value
            : '';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 40.px,
                  color: ColorsLight.Lv1,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.px, vertical: 6.px),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TRẠNG THÁI',
                        style: AppTextStyle.textStyle.s16().w700().cN5(),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.px, vertical: 6.px),
                        decoration: BoxDecoration(
                          color: ColorsPrimary.Lv5,
                          borderRadius: BorderRadius.circular(6.px),
                        ),
                        child: Text(
                          // checkStatus(data.data?.documentStatus ?? 0),
                          data.data != null
                              ? (widget.idDocument != data.data?.documentId
                                  ? ''
                                  : (data.data!.documentStatus == 1 &&
                                          !data.data!.canSign!)
                                      ? 'Chờ phê duyệt'
                                      : checkStatus(
                                          data.data?.documentStatus ?? 0))
                              : '',
                          style: AppTextStyle.textStyle.s10().w700().cP5(),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 1.px),
                Visibility(
                  visible: data.data != null
                      ? (data.data!.documentStatus == 1 && data.data!.canSign!)
                      : false,
                  child: Container(
                    color: ColorsLight.Lv1,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.px, vertical: 16.px),
                    child: Container(
                      padding: EdgeInsets.all(16.px),
                      decoration: BoxDecoration(
                        color: ColorsWarn.Lv5,
                        borderRadius: BorderRadius.circular(10.px),
                        border: Border.all(color: ColorsWarn.Lv2),
                      ),
                      child: Text(
                        'Đảm bảo rằng bạn sẽ kiểm tra kỹ toàn bộ nội dung dưới đây',
                        style: AppTextStyle.textStyle.s16().w500().cN5(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.px),
                  child: ContainerInfo(
                    list: [
                      Text(
                        'THÔNG TIN HỢP ĐỒNG',
                        style: AppTextStyle.textStyle.s16().w700().cN5(),
                      ),
                      ..._buildMetaData(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.px,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.px, 0, 20.px, 16.px),
                  child: ContainerInfo(
                    list: [
                      Text(
                        'VĂN BẢN HỢP ĐỒNG',
                        style: AppTextStyle.textStyle.s16().w700().cN5(),
                      ),
                      SizedBox(
                        height: 16.px,
                      ),
                      Container(
                        height: 350.px,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.px),
                            color: ColorsWhite.Lv1,
                            border: Border.all(color: ColorsGray.Lv1)),
                        margin: const EdgeInsets.symmetric(horizontal: 34),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.px),
                          child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                            builder: (context, state) {
                              if (state is UserRemoteGetDoneData &&
                                  state.PDFFiles != null) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 350.px,
                                      padding: EdgeInsets.only(top: 24.px),
                                      child: PDFView(
                                        filePath: state.PDFFiles?.path,
                                        defaultPage: 0,
                                        fitPolicy: FitPolicy.BOTH,
                                        onError: (e) {},
                                      ),
                                    ),
                                    Center(
                                        child: InkWell(
                                      onTap: () {
                                        AppNavigator.push(Routes.DETAIL_PDF,
                                            arguments: {
                                              'namePdf': data
                                                  .data?.filePreviewUrl
                                                  ?.split('?')[0]
                                                  .split('/')
                                                  .last
                                            });
                                      },
                                      child: Container(
                                          height: 35.px,
                                          width: 100.px,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.px),
                                            color: Color(0xFF484E59)
                                                .withOpacity(0.12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Xem chi tiết',
                                              style: AppTextStyle.textStyle
                                                  .s16()
                                                  .w400()
                                                  .cN5(),
                                            ),
                                          )),
                                    ))
                                  ],
                                );
                              }
                              return CoverLoading();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.px,
                      ),
                      if (data.data != null)
                        (!data.data!.canSign!)
                            ? InkWell(
                                onTap: () {
                                  AppBlocs.userRemoteBloc.add(
                                    UserRemoteCheckSignatureEvent(
                                        idDoc: AppBlocs
                                                .userRemoteBloc
                                                .contractDetailResponse
                                                .data
                                                ?.documentId ??
                                            ''),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Kiểm tra chữ ký số",
                                      style: AppTextStyle.textStyle
                                          .s14()
                                          .w700()
                                          .cP5(),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.navigate_next_outlined,
                                      color: ColorsPrimary.Lv1,
                                    )
                                  ],
                                ),
                              )
                            : SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          color: ColorsWhite.Lv1,
          child: Column(
            children: [
              SizedBox(
                height: 16.px,
              ),
              widget.idDocument != data.data?.documentId
                  ? const SizedBox()
                  : (data.data?.canSign ?? false)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ButtonPop2(
                                    buttonTitle: 'Từ chối',
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return RefuseSign(
                                              documentId: widget.idDocument);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 13.px),
                                Expanded(
                                  child: ButtonPrimary(
                                    padding: EdgeInsets.zero,
                                    content: 'Ký hợp đồng',
                                    onTap: () {
                                      _isCheck1 = false;
                                      _isCheck2 = false;
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: ColorsLight.Lv1,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                        ),
                                        context: context,
                                        builder: (builder) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 24, 20, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Xác nhận Ký hợp đồng $docName',
                                                    style: AppTextStyle
                                                        .textStyle
                                                        .s16()
                                                        .w700()
                                                        .cN5(),
                                                  ),
                                                  SizedBox(
                                                    height: 24.px,
                                                  ),
                                                  Row(
                                                    children: [
                                                      CheckBoxCustom(
                                                        isChecked: _isCheck1,
                                                        onPress: (v) {
                                                          setState(() {
                                                            _isCheck1 =
                                                                !_isCheck1;
                                                          });
                                                        },
                                                      ),
                                                      Flexible(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            text:
                                                                'Tôi đã đọc và đồng ý ',
                                                            style: AppTextStyle
                                                                .textStyle
                                                                .s16()
                                                                .w400()
                                                                .cN5(),
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      'phương thức giao dịch điện tử ',
                                                                  style: AppTextStyle
                                                                      .textStyle
                                                                      .s16()
                                                                      .w700()
                                                                      .cN5()
                                                                      .underline(),
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {
                                                                          // AppBlocs.userRemoteBloc.add(UserRemoteGetPDFeFormEvent(PDFLink: data.data?.eForm?.fileUrl ?? ''));
                                                                          AppNavigator.push(
                                                                              Routes.EFORM_PDF,
                                                                              arguments: {
                                                                                'namePdf': data.data?.eForm?.fileUrl?.split('?')[0].split('/').last
                                                                              });
                                                                        }),
                                                              TextSpan(
                                                                  text:
                                                                      'của $UNIT_NAME_CAP.',
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {},
                                                                  style: AppTextStyle
                                                                      .textStyle
                                                                      .s16()
                                                                      .w400()
                                                                      .cN5()),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 16.px,
                                                  ),
                                                  Row(
                                                    children: [
                                                      CheckBoxCustom(
                                                        isChecked: _isCheck2,
                                                        onPress: (v) {
                                                          setState(() {
                                                            _isCheck2 =
                                                                !_isCheck2;
                                                          });
                                                        },
                                                      ),
                                                      Flexible(
                                                          child: Text(
                                                              'Tôi xác nhận đã được $UNIT_NAME_CAP cung cấp đầy đủ thông tin.',
                                                              style:
                                                                  AppTextStyle
                                                                      .textStyle
                                                                      .s16()
                                                                      .w400()
                                                                      .cN5())),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 16.px,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ButtonPop2(
                                                          buttonTitle:
                                                              'Quay lại',
                                                          // onTap: () {},
                                                        ),
                                                      ),
                                                      SizedBox(width: 13.px),
                                                      Expanded(
                                                        child: ButtonPrimary(
                                                          enable: _isCheck1 &&
                                                              _isCheck2,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          content: 'Xác nhận',
                                                          onTap: () async {
                                                            showDialogLoading();
                                                            LocationPermission
                                                                permission;
                                                            permission =
                                                                await Geolocator
                                                                    .checkPermission();
                                                            if (permission ==
                                                                    LocationPermission
                                                                        .always ||
                                                                permission ==
                                                                    LocationPermission
                                                                        .whileInUse) {
                                                              /// app luôn bật location hoặc bật khi sử dụng app
                                                              AppNavigator
                                                                  .pop();
                                                              AppNavigator
                                                                  .pop();
                                                              AppBlocs
                                                                  .userRemoteBloc
                                                                  .add(
                                                                      UserRemoteSigningEFormEvent());

                                                              /// ký eform
                                                            } else {
                                                              /// app từ chối quyền location
                                                              AppNavigator
                                                                  .pop();
                                                              await GeolocatorHelper()
                                                                  .getCurrentPosition()
                                                                  .then(
                                                                      (value) async {
                                                                if (value !=
                                                                    null) {
                                                                  AppBlocs
                                                                      .userRemoteBloc
                                                                      .add(
                                                                          UserRemoteSigningEFormEvent());
                                                                } else {
                                                                  await openAppSettings();
                                                                }
                                                              });

                                                              /// vào setting máy
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 42.px,
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 42.px,
                            )
                          ],
                        )
                      : ButtonPrimary(
                          content: 'Đóng',
                          onTap: () {
                            AppNavigator.pop();
                          },
                        ),
            ],
          ),
        ),
      ],
    );
  }
}
