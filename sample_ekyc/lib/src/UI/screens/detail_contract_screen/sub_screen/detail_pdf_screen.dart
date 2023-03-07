import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';

import 'package:hdsaison_signing/src/BLOC/user_remote/user_remote_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/buttons/button_primary.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/loading/cover_loading.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../designs/app_themes/app_assets_links.dart';

class DetailPDFScreen extends StatefulWidget {
  final String namePdf;
  DetailPDFScreen({Key? key, required this.namePdf}) : super(key: key);

  @override
  State<DetailPDFScreen> createState() => _DetailPDFScreenState();
}

class _DetailPDFScreenState extends State<DetailPDFScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      appBar: MyAppBar(
        widget.namePdf,
        icon: InkWell(
          onTap: () async {
            /// share file
            await Share.shareXFiles([
              XFile(AppBlocs.userRemoteBloc.PDFFiles?.path ?? '',
                  mimeType: 'pdf', name: widget.namePdf)
            ]);
          },
          child: SvgPicture.asset(AppAssetsLinks.ic_share),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                builder: (context, state) {
                  if (state is UserRemoteGetDoneData &&
                      state.PDFFiles != null) {
                    return Container(
                      height: 100.h,
                      width: 100.w,
                      padding: EdgeInsets.only(top: 24.px),
                      child: PDFView(
                        filePath: state.PDFFiles?.path,
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
                  onTap: () {
                    AppNavigator.pop();
                  },
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
