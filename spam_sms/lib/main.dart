import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/routes/app_screens.dart';
import 'package:spam_sms/core/theme/app_theme.dart';
import 'package:spam_sms/features/app_controller.dart';
import 'package:spam_sms/features/send_from_excel/view/send_from_excel_screen.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(AppController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spam SMS',
      theme: AppTheme.lightTheme,
      getPages: AppScreens.pages,
      home: const SendFromExcelScreen(),
    );
  }
}
