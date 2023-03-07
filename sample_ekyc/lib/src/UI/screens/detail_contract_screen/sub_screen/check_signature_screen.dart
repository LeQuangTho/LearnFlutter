import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../BLOC/app_blocs.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../../user_profile/sub_screens/user_info_screen.dart';
import '../../../../extentions/type_extesions.dart';
import '../../../../helpers/date_time_helper.dart';
import '../../../../navigations/app_pages.dart';
import 'package:intl/intl.dart';

import '../../../../BLOC/user_remote/models/check_signature_response/check_signature_response.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../designs/app_themes/app_text_styles.dart';

class CheckSignatureScreen extends StatelessWidget {
  const CheckSignatureScreen({Key? key}) : super();

  bool isNotValidSignature(UserRemoteGetDoneData state) {
    try {
      return state.checkSignatureResponse?.data?.dataRes?.signatures
              ?.firstWhere((e) => e.documentResult?.signatureValid == false) !=
          null;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssetsLinks.background_otp_sc,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                  builder: (context, state) {
                    if (state is UserRemoteGetDoneData) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: kToolbarHeight.px),
                            SvgPicture.asset(isNotValidSignature(state)
                                ? AppAssetsLinks.fail
                                : AppAssetsLinks.success),
                            SizedBox(height: 16.px),
                            Text(
                              isNotValidSignature(state)
                                  ? 'Tài liệu không hợp lệ'
                                  : 'Kết quả kiểm tra hợp lệ',
                              style: AppTextStyle.textStyle.s24().w700().cN5(),
                            ),
                            SizedBox(height: 8.px),
                            Text(
                              isNotValidSignature(state)
                                  ? 'Chữ ký số trên tài liệu không hợp lệ'
                                  : 'Tất cả chữ ký số trên tài liệu đều hợp lệ',
                              style: AppTextStyle.textStyle.s16().w400().cN4(),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32.px),
                            ContainerInfo(
                              list: [
                                InfoField(
                                  first: true,
                                  title: 'TÀI LIỆU',
                                  content: state.checkSignatureResponse?.data
                                      ?.dataRes?.name
                                      ?.split('/')
                                      .last,
                                ),
                                InfoField(
                                  title: 'THỜI GIAN XÁC THỰC',
                                  content: dateTimeFormat4(state
                                          .checkSignatureResponse
                                          ?.data
                                          ?.dataRes
                                          ?.time ??
                                      ''),
                                ),
                                InfoField(
                                  title: 'SỐ LƯỢNG CHỮ KÝ',
                                  content:
                                      '${state.checkSignatureResponse?.data?.dataRes?.signatureAmount ?? ''}',
                                ),
                              ],
                            ),
                            SizedBox(height: 16.px),
                            Wrap(
                              runSpacing: 16.px,
                              children: state.checkSignatureResponse?.data
                                      ?.dataRes?.signatures
                                      ?.map(
                                        (e) => ItemSignature(signatures: e),
                                      )
                                      .toList() ??
                                  [],
                            ),
                            SizedBox(height: 24.px),
                          ],
                        ),
                      );
                    }
                    return CoverLoading();
                  },
                ),
              ),
              ButtonPrimary(
                onTap: () => AppNavigator.pop(),
                content: 'Hoàn thành',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemSignature extends StatefulWidget {
  const ItemSignature({Key? key, required this.signatures}) : super(key: key);

  final Signatures signatures;

  @override
  State<ItemSignature> createState() => _ItemSignatureState();
}

class _ItemSignatureState extends State<ItemSignature>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late bool hasUID;

  bool _isShow = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation =
        Tween(begin: _isShow ? 0.0 : 0.0, end: _isShow ? 0.0 : 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    hasUID = widget.signatures.certificateInfo?.subjectDn
            ?.cutString(type: 'UID=')
            .isNotEmpty ==
        true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapTitle() {
    setState(() {
      _isShow = !_isShow;
    });
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    final date = DateFormat('dd/MM/yyyy').parse('20/12/1996');

    print(date);
  }

  bool checkValid() {
    return widget.signatures.certificateResult?.checkValidSignedTime ==
            'VALID' &&
        widget.signatures.certificateResult?.checkRevokeSignedTime == 'GOOD';
  }

  String getNameSignature() {
    return '${hasUID ? 'Chữ ký số' : 'Chữ ký điện tử an toàn'} - ${hasUID ? widget.signatures.certificateInfo?.subjectDn?.cutString(type: 'CN=') : AppBlocs.userRemoteBloc.userResponseDataEntry.name ?? ''}';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: _onTapTitle,
      child: Container(
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.px),
          color: ColorsLight.Lv1,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15), //color of shadow
              spreadRadius: 0, //spread radius
              blurRadius: 2, // blur radius
              offset: Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getNameSignature(),
                        style: AppTextStyle.textStyle.s16().w500().cN5(),
                      ),
                      SizedBox(height: 4.px),
                      Text(
                        dateTimeFormat4(
                            widget.signatures.documentInfo?.signedTime ?? ''),
                        style: AppTextStyle.textStyle.s12().w400().cN4(),
                      ),
                      SizedBox(height: 8.px),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: widget.signatures.documentResult
                                          ?.signatureValid ==
                                      true
                                  ? ColorsSuccess.Lv5
                                  : ColorsWarn.Lv5,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              widget.signatures.documentResult
                                          ?.signatureValid ==
                                      true
                                  ? "CHỮ KÝ HỢP LỆ"
                                  : "CHỮ KÝ KHÔNG HỢP LỆ",
                              style:
                                  AppTextStyle.textStyle.s10().w700().copyWith(
                                        color: widget.signatures.documentResult
                                                    ?.signatureValid ==
                                                true
                                            ? ColorsSuccess.Lv1
                                            : ColorsWarn.Lv2,
                                      ),
                            ),
                          ),
                          SizedBox(width: 8.px),
                          if (widget.signatures.documentAdvanced?.ltv == true)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Color(0xFFE3F2FD),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text(
                                "XÁC THỰC LÂU DÀI",
                                style: AppTextStyle.textStyle
                                    .s10()
                                    .w700()
                                    .copyWith(
                                      color: Color(0xFF2196F3),
                                    ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isShow
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Container(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: hasUID
                    ? [
                        SizedBox(height: 16.px),
                        Divider(height: 1.px),
                        SizedBox(height: 16.px),
                        Text(
                          'Thông tin chữ ký',
                          style: AppTextStyle.textStyle.s16().w500().cN5(),
                        ),
                        buildRowContent(
                          'Dấu thời gian',
                          widget.signatures.documentAdvanced?.tsaTime == null
                              ? 'Không'
                              : 'Có',
                        ),
                        buildRowContent(
                          'Thời gian ký',
                          dateTimeFormat4(
                            widget.signatures.documentAdvanced?.tsaTime ??
                                widget.signatures.documentInfo?.signedTime ??
                                '',
                          ),
                        ),
                        SizedBox(height: 16.px),
                        Text(
                          'Thông tin chứng thư số người ký',
                          style: AppTextStyle.textStyle.s16().w500().cN5(),
                        ),
                        buildRowContent(
                          'Họ và tên',
                          widget.signatures.certificateInfo?.subjectDn
                              ?.cutString(type: 'CN='),
                        ),
                        buildRowContent(
                          'Số CMND/CCCD/Hộ chiếu',
                          widget.signatures.certificateInfo?.subjectDn
                              ?.cutString(type: 'UID='),
                        ),
                        buildRowContent(
                          'Tỉnh/ Thành phố',
                          widget.signatures.certificateInfo?.subjectDn
                              ?.cutString(type: 'ST='),
                        ),
                        buildRowContent(
                          'Quốc gia',
                          widget.signatures.certificateInfo?.subjectDn
                              ?.cutString(type: 'C='),
                        ),
                        buildRowContent(
                          'Hiệu lực từ',
                          dateTimeFormat4(widget
                                  .signatures.certificateInfo?.certValidFrom ??
                              ''),
                        ),
                        buildRowContent(
                          'Hiệu lực đến',
                          dateTimeFormat4(
                              widget.signatures.certificateInfo?.certValidTo ??
                                  ''),
                        ),
                        buildRowContent(
                          'Trạng thái chứng thư số tại thời điểm ký',
                          checkValid() ? 'Còn hiệu lực' : 'Hết hiệu lực',
                          contentStyle: checkValid()
                              ? AppTextStyle.textStyle.s12().w400().cG5()
                              : AppTextStyle.textStyle.s12().w400().cP5(),
                        ),
                        buildRowContent(
                          'Phương thức kiểm tra',
                          widget.signatures.certificateResult
                                  ?.checkRevokeSignedTimeMethod ??
                              '',
                        ),
                        SizedBox(height: 16.px),
                        Text(
                          'Thông tin chứng thư số tổ chức phát hành CTS',
                          style: AppTextStyle.textStyle.s16().w500().cN5(),
                        ),
                        buildRowContent(
                          'Tổ chức',
                          widget
                              .signatures.certificateInfo?.certificateAuthority
                              ?.cutString(type: 'CN='),
                        ),
                        buildRowContent(
                          'Trạng thái chứng thư số tại thời điểm ký',
                          'Còn hiệu lực',
                          contentStyle:
                              AppTextStyle.textStyle.s12().w400().cG5(),
                        ),
                      ]
                    : [
                        SizedBox(height: 16.px),
                        Divider(height: 1.px),
                        SizedBox(height: 16.px),
                        Text(
                          'Thông tin chữ ký',
                          style: AppTextStyle.textStyle.s16().w500().cN5(),
                        ),
                        buildRowContent(
                          'Họ và tên',
                          AppBlocs.userRemoteBloc.userResponseDataEntry.name ??
                              '',
                        ),
                        buildRowContent(
                          'Số CMND/CCCD/Hộ chiếu',
                          AppBlocs.userRemoteBloc.userResponseDataEntry
                                  .identityNumber ??
                              '',
                        ),
                        buildRowContent(
                          'Ký số timestamp bởi',
                          widget.signatures.certificateInfo?.subjectDn
                              ?.cutString(type: 'CN='),
                        ),
                        buildRowContent(
                          'Thời gian ký',
                          dateTimeFormat4(
                            widget.signatures.documentAdvanced?.tsaTime ??
                                widget.signatures.documentInfo?.signedTime ??
                                '',
                          ),
                        ),
                        buildRowContent(
                          'Số điện thoại',
                          AppBlocs.userRemoteBloc.userResponseDataEntry
                                  .phoneNumber ??
                              '',
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildRowContent(String title, String? content,
      {TextStyle? contentStyle}) {
    return Padding(
      padding: EdgeInsets.only(top: 8.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: AppTextStyle.textStyle.s12().w400().cN5(),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              content ?? '',
              style: contentStyle ?? AppTextStyle.textStyle.s12().w400().cN5(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
