import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:flutter/material.dart';
import '../../utils/recog_result_status.dart';
import 'package:image/image.dart' as imglib;
import 'package:sample_sdk_flutter/src/screens/card_front_validation/card_preview_dialog.dart';

class PreviewCardScreen extends StatefulWidget {
  imglib.Image? imShow;
  String? imagePath;
  String? rawImagePath;
  late bool cardValidationResult;
  late String message;

  Future<void> Function() backCardRecogScreenCallback;

  PreviewCardScreen(
      {Key? key,
      required this.cardValidationResult,
      required this.message,
      required this.backCardRecogScreenCallback,
      this.imShow,
      this.imagePath,
      this.rawImagePath})
      : super(key: key);

  @override
  _PreviewCardScreenState createState() => _PreviewCardScreenState();
}

class _PreviewCardScreenState extends State<PreviewCardScreen> {
  RecogResultStatus recogResultStatus = RecogResultStatus.blurryCard;
  bool isUploading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // check
    callPopup();
  }

  callPopup() async {
    if (widget.cardValidationResult == true) {
      Future.delayed(
          Duration.zero,
          () => showCardPreviewDialog(
              context, widget.backCardRecogScreenCallback,
              imagePath: widget.imagePath, rawImagePath: widget.rawImagePath));
    } else {
      Future.delayed(
          Duration.zero,
          () => showFailedCardPreviewDialog(
              context, widget.backCardRecogScreenCallback,
              imagePath: widget.imagePath, message: widget.message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PrimaryAppBar(
            appBar: AppBar(),
            iconColor: Colors.white,
            text: "Xác định danh tính"),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
