import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? progress;
  String? linkPath;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isAndroid) {
        final downloadPathAndroid =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);
        linkPath = '$downloadPathAndroid/test.jpg';
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: File(linkPath ?? '').existsSync()
            ? Center(
                child: Column(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text('Done')
                  ],
                ),
              )
            : Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    color: Colors.yellow,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('${progress?.toStringAsFixed(2)}%'),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            progress = null;
          });
          if (await Permission.storage.request().isGranted) {
            Dio dio = Dio();
            if (Platform.isIOS) {
              final pathDir =
                  (await getApplicationDocumentsDirectory()).path.split('/');

              print(pathDir.reduce((value, element) => '$value/$element'));
              final indexOfData = pathDir.indexOf('Data');
              print(linkPath);
              linkPath =
                  '${pathDir.take(indexOfData + 1).reduce((value, element) => '$value/$element')}/test.png';
              print(linkPath);
            }
            //767DFDAA-AAFF-4C17-8155-D523A7E26DF5
            await dio.download('https://bit.ly/3gZOsyu', linkPath,
                onReceiveProgress: (received, total) {
              if (total != -1) {
                setState(() {
                  progress = received / total * 100.0;
                });
              }
            });
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
