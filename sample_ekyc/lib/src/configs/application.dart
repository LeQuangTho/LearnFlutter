import 'package:flutter/material.dart';
import 'package:hdsaison_signing/src/repositories/local/base_local_repository.dart';
import 'package:hdsaison_signing/src/services/sdk_ekyc/sdk_callback.dart';

import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import '../constants/hard_constants.dart';
import '../services/firebase_mess.dart';

class AppData {
  /// [Production - DEV]
  static const String mode = MODE_DEV;

  // Only for working in office
  static const String office_base_url = '192.168.11.13:3333';
  static const String baseUrl =
      'https://sandbox-apim.savis.vn/e-contract-mobile/v1/';
  static bool isShowingError = false;

  static  SdkConfig? sdkConfig;


  void initSdkConfig() {
    sdkConfig = SdkConfig(
        apiUrl: "https://sandbox-apim.savis.vn/ekyc-fpt/v1/api",
        source: "pvcb_pilot",
        env: "dev",
        token: "",
        timeOut: 20,
        email: "",
        phone: "",
        backRoute: "/",
        sdkCallback: SdkCallbackExt());
  }

  Future<void> initialApplicationData(BuildContext context) async {
    try {
      await BaseLocalData.initialBox();
      await getFirebaseMessagingToken();
      await requestPermission();
    } catch (e) {}
  }


  /// Singleton factory
  AppData._internal();
  static final AppData _instance = AppData._internal();
  factory AppData() {
    return _instance;
  }



}
