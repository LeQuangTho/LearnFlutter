import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      supportMultipleWindows: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("JavaScript Handlers")),
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
//                 initialData: InAppWebViewInitialData(data: """
// <!DOCTYPE html>
// <html lang="en">
//     <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//     </head>
//     <body>
//         <h1>JavaScript Handlers</h1>
//
//         <script>
//             window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
//                 window.flutter_inappwebview.callHandler('handlerFoo')
//                   .then(function(result) {
//                     // print to the console the data coming
//                     // from the Flutter side.
//                     console.log(JSON.stringify(result));S
//
//                     window.flutter_inappwebview
//                       .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
//                 });
//             });
//         </script>
//     </body>
// </html>
//                       """),
                initialOptions: options,
                initialUrlRequest: URLRequest(
                  url: Uri.parse("https://nagakingdom.com/"),
                ),

                onCreateWindow: (controller, createWindowAction) async {
                  // print(await createWindowAction.iosWindowFeatures);
                  return true;
                },
                onWindowFocus: (controller) async {
                  // print(await controller.getUrl());
                },

                onProgressChanged: (controller, progress) async {},
                // onWebViewCreated: (controller) async {
                //   controller.addJavaScriptHandler(
                //       handlerName: 'handlerFoo',
                //       callback: (args) {
                //         // return data to the JavaScript side!
                //         return {'bar': 'bar_value', 'baz': 'baz_value'};
                //       });
                //
                //   controller.addJavaScriptHandler(
                //       handlerName: 'handlerFooWithArgs',
                //       callback: (args) {
                //         print(args);
                //         // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                //       });
                //   print(await controller.webStorage.sessionStorage);
                // },
                // onConsoleMessage: (controller, consoleMessage) {
                //   print(consoleMessage);
                //   // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                // },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
