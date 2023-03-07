import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../navigations/app_pages.dart';
import '../../../common_widgets/buttons/button_primary.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/layouts/appbar_common.dart';

class DetailPDFEformCTSScreen extends StatelessWidget {
  DetailPDFEformCTSScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsGray.Lv3,
      appBar: MyAppBar('Ký đơn đề nghị cấp CTS'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                builder: (context, state) {
                  if (state is UserRemoteGetDoneData &&
                      state.PDFFilesEFormCTS != null) {
                    return Container(
                      child: PDFView(
                        filePath: state.PDFFilesEFormCTS?.path,
                        defaultPage: 0,
                        fitPolicy: FitPolicy.BOTH,
                        onError: (e) {},
                      ),
                    );
                  }
                  return CoverLoading();
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ButtonPrimary(
                  onTap: () => AppNavigator.pop(),
                  content: 'Quay lại',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
