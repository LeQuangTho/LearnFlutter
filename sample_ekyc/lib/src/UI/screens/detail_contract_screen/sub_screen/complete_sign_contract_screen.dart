import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../navigations/app_pages.dart';
import '../../../../navigations/app_routes.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';

class CompleteSignContractScreen extends StatefulWidget {
  const CompleteSignContractScreen({Key? key}) : super(key: key);

  @override
  State<CompleteSignContractScreen> createState() =>
      _CompleteSignContractScreenState();
}

class _CompleteSignContractScreenState
    extends State<CompleteSignContractScreen> {
  @override
  void initState() {  
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 68.px,
                  ),
                  Text(
                    'Tài liệu đã được ký',
                    style: AppTextStyle.textStyle.s24().w700().cN5(),
                  ),
                  SizedBox(
                    height: 16.px,
                  ),
                  Text(
                    'Kết quả kích hoạt thẻ sẽ được gửi tới bạn thông qua SMS và thông báo của ứng dụng',
                    style: AppTextStyle.textStyle.s16().w400().cN4(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24.px,
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
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        AppNavigator.push(Routes.DETAIL_PDF,
                                            arguments: {
                                              'namePdf': AppBlocs
                                                  .userRemoteBloc
                                                  .contractDetailResponse
                                                  .data
                                                  ?.filePreviewUrl
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
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                          return CoverLoading();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.px,
                  ),
                  InkWell(
                    onTap: () {
                      AppBlocs.userRemoteBloc.add(
                        UserRemoteCheckSignatureEvent(
                            idDoc: AppBlocs.userRemoteBloc
                                    .contractDetailResponse.data?.documentId ??
                                ''),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kiểm tra chữ ký số",
                          style: AppTextStyle.textStyle.s14().w700().cP5(),
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
                ],
              ),
            ),
            Container(
              color: ColorsLight.Lv1,
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: ButtonPrimary(
                onTap: () {
                  AppNavigator.popUntil(Routes.DETAIL_CONTRACT);
                },
                content: 'Hoàn thành',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
