import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/loading/cover_loading.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/layouts/appbar_common.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key? key, required this.link, required this.title})
      : super(key: key);
  final String link;
  final String title;

  @override
  State<WebViewScreen> createState() => _AssetsPDFViewScreenState();
}

class _AssetsPDFViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;

  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      appBar: MyAppBar(widget.title),
      body: Stack(
        children: [
          WebView(
            onWebViewCreated: ((controller) {
              _controller = controller;
              print("onWebViewCreated");
            }),
            // onProgress: (progress) async{
            //   print("onProgress $progress");
            // },
            // onPageStarted: (url) async{
            //   print("onPageStarted");
            // },
            backgroundColor: ColorsLight.Lv1,
            initialUrl: widget.link,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) async {
              print("onPageFinished");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('mnfixed_wrap')[0].style.display='none';");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('breadcrumb')[0].style.display='none';");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('boxTitlePage')[0].style.display='none';");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('contactFoot')[0].style.display='none';");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('mainFooter')[0].style.display='none';");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('botFoot')[0].style.display='none';");
              await _controller!.runJavascript(
                  "document.getElementsByClassName('item_toolbar')[0].style.display='none';");
              await Future.delayed(DELAY_1_S);
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: ColorsWhite.Lv1,
                  child: Center(
                    child: SpinKitFadingFour(
                      size: 40,
                      color: ColorsPrimary.Lv1,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
