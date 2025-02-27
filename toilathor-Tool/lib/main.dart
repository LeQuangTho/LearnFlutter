import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() => runApp(
      GetMaterialApp(
        title: 'toilathor',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        print("Shared:${_sharedFiles?.map((f) => f.path).join(",") ?? ""}");
        _sharedFiles = value;
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    ReceiveSharingIntent.getInitialText().then(
      (String? value) {
        setState(() {
          _sharedText = value ?? 'Không nhận được';
        });
      },
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text("Shared files:", style: textStyleBold),
            Text(_sharedFiles?.map((f) => f.path).join(",") ?? ""),
            const SizedBox(height: 100),
            const Text("Shared urls/text:", style: textStyleBold),
            Text(_sharedText ?? "")
          ],
        ),
      ),
    );
  }
}
