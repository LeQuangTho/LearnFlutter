import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import 'package:sample_sdk_flutter/src/models/device_infor.dart';
import 'package:sample_sdk_flutter/src/models/ekyc_session.dart';

class AppConfig {
  AppConfig._() {
    eKycSessionInfor = EKycSessionInfor();
  }
  static bool isInit = false;
  static AppConfig _instance = AppConfig._();
  factory AppConfig() => _instance;
  String apiUrl = "https://sandbox-apim.savis.vn/ekyc-fpt/v1/api";
  String source = "VDT";
  String env = "dev";
  String token = "4780bba4704800149fca952cb20fb276d8245c11";
  int timeOut = 10;
  String email = "";
  String phone = "";
  late DeviceInfor deviceInfor;
  late EKycSessionInfor eKycSessionInfor;
  late String backRoute = "/";
  SdkCallback? sdkCallback;
}
