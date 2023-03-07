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

class ViewEFormScreen extends StatefulWidget {
  final String namePdf;
  ViewEFormScreen({Key? key, required this.namePdf}) : super(key: key);

  @override
  State<ViewEFormScreen> createState() => _ViewEFormScreenState();
}

class _ViewEFormScreenState extends State<ViewEFormScreen> {
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
            await Share.shareXFiles([
              XFile(AppBlocs.userRemoteBloc.PDFFilesEForm?.path ?? '',
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
                      state.PDFFilesEForm != null) {
                    return Container(
                      height: 100.h,
                      width: 100.w,
                      child: PDFView(
                        filePath: state.PDFFilesEForm?.path,
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
