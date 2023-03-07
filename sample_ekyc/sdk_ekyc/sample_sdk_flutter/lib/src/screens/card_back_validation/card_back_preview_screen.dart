import 'package:flutter/material.dart';
import '../../utils/recog_result_status.dart';
import 'package:image/image.dart' as imglib;
import 'package:sample_sdk_flutter/src/screens/card_back_validation/card_back_preview_dialog.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';

class PreviewCardBackScreen extends StatefulWidget {
  imglib.Image? imShow;
  String? rawImagePath;
  String? imagePath;
  late bool cardValidationResult;
  late String message;

  Future<void> Function() backCardRecogScreenCallback;

  PreviewCardBackScreen(
      {Key? key,
      required this.cardValidationResult,
      required this.message,
      required this.backCardRecogScreenCallback,
      this.imShow,
      this.imagePath,
      this.rawImagePath})
      : super(key: key);

  @override
  _PreviewCardBackScreenState createState() => _PreviewCardBackScreenState();
}

class _PreviewCardBackScreenState extends State<PreviewCardBackScreen> {
  RecogResultStatus recogResultStatus = RecogResultStatus.blurryCard;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
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
              imagePath: widget.imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
          appBar: AppBar(),
          iconColor: Colors.white,
          text: "Xác định danh tính"),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}
