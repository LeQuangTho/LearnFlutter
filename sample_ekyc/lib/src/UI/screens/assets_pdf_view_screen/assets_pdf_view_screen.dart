import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import '../../designs/app_themes/app_colors.dart';
import '../../designs/layouts/appbar_common.dart';

class AssetsPDFViewScreen extends StatefulWidget {
  AssetsPDFViewScreen({Key? key, required this.filePath}) : super(key: key);
  final String filePath;

  @override
  State<AssetsPDFViewScreen> createState() => _AssetsPDFViewScreenState();
}

class _AssetsPDFViewScreenState extends State<AssetsPDFViewScreen> {
  String path = '';
  @override
  void initState() {
    super.initState();
    fromAsset(widget.filePath, widget.filePath.split('/').last).then((file) {
      setState(() {
        path = file.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      print('${file.path}');
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsLight.Lv1,
      appBar: MyAppBar('Điều khoản và điều kiện'),
      body: path.isNotEmpty
          ? Container(
              child: PDFView(
                filePath: path,
                defaultPage: 0,
                fitPolicy: FitPolicy.BOTH,
                onError: (e) {},
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
