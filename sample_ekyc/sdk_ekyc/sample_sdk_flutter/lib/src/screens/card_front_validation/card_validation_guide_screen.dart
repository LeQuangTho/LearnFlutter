import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import 'package:sample_sdk_flutter/src/components/loading_dialog.dart';
import 'package:sample_sdk_flutter/src/components/primary_button.dart';
import 'package:sample_sdk_flutter/src/utils/background_stack.dart';
import 'package:sample_sdk_flutter/src/utils/server_error_code_handler.dart';
import 'package:sample_sdk_flutter/src/components/time_out_dialog.dart';
import 'package:sample_sdk_flutter/src/models/device_infor.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/api_helper.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/components/custom_text_style.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';


class CardValidationGuideScreen extends StatefulWidget {
  SdkConfig? sdkConfig;
  CardValidationGuideScreen({required this.sdkConfig, Key? key})
      : super(key: key);

  @override
  _CardValidationGuideScreenState createState() =>
      _CardValidationGuideScreenState();
}

class _CardValidationGuideScreenState extends State<CardValidationGuideScreen> {
  bool _isCallingApi = false;
  bool _initSuccess = false;

  @override
  void initState() {
    super.initState();
    initSdkConfig();
    startEkycSession();
  }

  void initSdkConfig() {
    if (widget.sdkConfig == null) {
      print("generateSessionID widget.sdkConfig == null");
    }
    if (widget.sdkConfig != null && !AppConfig.isInit) {
      AppConfig.isInit = true;
      AppConfig().source = widget.sdkConfig!.source;
      AppConfig().apiUrl = widget.sdkConfig!.apiUrl;
      AppConfig().token = widget.sdkConfig!.token;
      AppConfig().timeOut = widget.sdkConfig!.timeOut;
      AppConfig().email = widget.sdkConfig!.email;
      AppConfig().phone = widget.sdkConfig!.phone;
      AppConfig().backRoute = widget.sdkConfig!.backRoute;
      // print("generateSessionID chen callback");
      AppConfig().sdkCallback = widget.sdkConfig!.sdkCallback;
      print("generateSessionID isinit = ${AppConfig.isInit}");
    }
  }

  Future<void> startEkycSession() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      var deviceData = androidDeviceInfo.toMap();
      DeviceInfor newDeviceInfor = DeviceInfor(
        newFingerPrint: deviceData['fingerPrint'].toString(),
        newHardware: deviceData['hardware'].toString(),
        newDevice: deviceData['device'].toString(),
        newType: deviceData['type'].toString(),
        newModel: deviceData['model'].toString(),
        newId: deviceData['id'].toString(),
      );
      AppConfig().deviceInfor = newDeviceInfor;
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      var iosDeviceInfor = iosDeviceInfo.toMap();
      DeviceInfor newDeviceInfor = DeviceInfor(
        newName: iosDeviceInfor['name'].toString(),
        newIosModel: iosDeviceInfor['model'].toString(),
        newSystemName: iosDeviceInfor['systemName'].toString(),
        newLocalizedModel: iosDeviceInfor['localizedModel'].toString(),
        newIdentifierForVendor:
            iosDeviceInfor['identifierForVendor'].toString(),
        newIsPhysicalDevice: iosDeviceInfor['isPhysicalDevice'].toString(),
      );
      AppConfig().deviceInfor = newDeviceInfor;
    }

    showLoadingDialog(context);
    var response = await ApiHelper.initEkycSession();
    if (response.output != null) {
      print("generateSessionID 1");
      if (AppConfig().sdkCallback != null) {
        print("generateSessionID callback");
        AppConfig()
            .sdkCallback!
            .generateSessionID(true, "", "", response.output!.id!);
      }
      Navigator.pop(context);
      setState(() {
        _initSuccess = true;
      });
    } else {
      Navigator.pop(context);
      if (response.code == "TIMEOUT") {
        showTimeOutDialog(context,
            message: getMessageFromErrorCode(response.code));
      } else {
        if (AppConfig().sdkCallback != null) {
          AppConfig().sdkCallback!.generateSessionID(
              false, response.code ??= "", response.error ??= "", "");
        }
      }
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
            ),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _getResponsiveBody();
  }

  Widget _getCardGuidelineDiaglog() {
    var size = MediaQuery.of(context).size;
    Future.delayed(Duration.zero, () => _buildPopupDialog(context));
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: size.height,
      width: double.infinity,
    ));
  }


  Widget _getResponsiveBody() {
    return Scaffold(
      appBar: PrimaryAppBar(
          appBar: AppBar(),
          iconColor: Colors.white,
          text: "Xác định danh tính"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _guideTitle()),
            Expanded(child: _validaCardGuide()),
            Expanded(child: _invalidCard()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const ImageIcon(
                          AssetImage(
                            "assets/images/tick_circle.png",
                            package: 'sample_sdk_flutter',
                          ),
                          color: kPrimaryGreen,
                          size: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Giấy tờ chính chủ và còn hạn sử dụng.",
                          style: getCustomTextStyle(
                            fontSize: 12,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        const ImageIcon(
                          AssetImage(
                            "assets/images/tick_circle.png",
                            package: 'sample_sdk_flutter',
                          ),
                          color: kPrimaryGreen,
                          size: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Là ảnh gốc, không scan và photocopy.",
                          style: getCustomTextStyle(
                            fontSize: 12,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        const ImageIcon(
                          AssetImage(
                            "assets/images/tick_circle.png",
                            package: 'sample_sdk_flutter',
                          ),
                          color: kPrimaryGreen,
                          size: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Ảnh chụp rõ ràng, đủ góc cạnh, không bị loá mờ\n nhay thiếu sáng..",
                          style: getCustomTextStyle(
                            fontSize: 12,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FractionallySizedBox(
                heightFactor: 0.4,
                widthFactor: 0.9,
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          CardValidationGuideScreen(sdkConfig: widget.sdkConfig),
                    ));
                        },
                  text: "Tiếp theo",
                  color: Colors.white,
                  backgroundColor: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
   // return BackgroundStack(
   //    child: Scaffold(
   //      appBar: PrimaryAppBar(
   //        appBar: AppBar(),
   //     iconColor: Colors.white,
   //     text: ""),
   //      body: Container(
   //        padding: EdgeInsets.symmetric(horizontal: 20.px),
   //        child: Column(
   //          children: [
   //            Expanded(
   //              child: Column(
   //                mainAxisAlignment: MainAxisAlignment.start,
   //                crossAxisAlignment: CrossAxisAlignment.start,
   //                children: [
   //                  SizedBox(height: 16.px),
   //                  Text(
   //                    'Chụp ảnh giấy tờ',
   //                    style: AppTextStyle.textStyle.s30().w700().cN5(),
   //                  ),
   //                  SizedBox(height: 4.px),
   //                  Text(
   //                    'Bạn vui lòng chọn 1 loại giấy tờ tùy thân để xác thực thông tin.',
   //                    style: AppTextStyle.textStyle.s16().w400().cN4(),
   //                  ),
   //                  SizedBox(height: 32.px),
   //                  ButtonHome(
   //                    title: 'CMND/CCCD',
   //                    icon: AppAssetsLinks.identity_doc,
   //                    onTap: () {
   //                      // AppNavigator.push(Routes.EKYC_CCCD);
   //
   //                    },
   //                  ),
   //                  SizedBox(height: 8.px),
   //                  ButtonHome(
   //                    title: 'Hộ chiếu',
   //                    icon: AppAssetsLinks.identity_doc,
   //                    onTap: () {
   //                      // AppNavigator.push(Routes.EKYC_PASSPORT);
   //                    },
   //                  ),
   //                  Padding(
   //                    padding: EdgeInsets.only(top: 32.px),
   //                    child: Text(
   //                      'Những lưu ý trước khi chụp giấy tờ',
   //                      style: AppTextStyle.textStyle.s16().w700().cN5(),
   //                    ),
   //                  ),
   //                  GuideSteps(
   //                    steps: [
   //                      'Giấy tờ của bạn sẽ được chụp theo thứ tự mặt trước -> mặt sau.',
   //                      'Đảm bảo giấy tờ của bạn là chính chủ, còn hạn sử dụng và là bản gốc.',
   //                      'Đảm bảo hình ảnh được chụp rõ nét, hình ảnh của giấy tờ nằm trong vùng chọn.',
   //                    ],
   //                  ),
   //                ],
   //              ),
   //            ),
   //          ],
   //        ),
   //      ),
   //    ),
   //  );
  }



  Widget _getCardGuidelineBody() {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PrimaryAppBar(
          appBar: AppBar(),
          iconColor: Colors.white,
          text: "Xác định danh tính"),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hướng dẫn xác thực danh tính",
                    style: getCustomTextStyle(
                      fontSize: 20,
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Các loại thẻ hợp lệ",
                          style: getCustomTextStyle(
                              fontSize: 17,
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Row contents vertically,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(9),
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/cccd_icon.png',
                                      package: 'sample_sdk_flutter', width: 60),
                                  SizedBox(height: 5),
                                  Text(
                                    "Căn cước \nCông dân",
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(9),
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/cmnd_icon.png',
                                      package: 'sample_sdk_flutter', width: 60),
                                  SizedBox(height: 5),
                                  Text(
                                    "Chứng minh \nNhân dân",
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(9),
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/passport_icon.png',
                                      package: 'sample_sdk_flutter', width: 35),
                                  SizedBox(height: 5),
                                  Text(
                                    "Hộ chiếu",
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Ảnh không hợp lệ",
                          style: getCustomTextStyle(
                              fontSize: 17,
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Row contents vertically,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/blur_icon.png',
                                      package: 'sample_sdk_flutter',
                                      width: 100),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Không chụp mờ",
                                    style: getCustomTextStyle(
                                      fontSize: 12,
                                      color: kPrimaryTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/images/cutting_edge_icon.png',
                                      package: 'sample_sdk_flutter',
                                      width: 100),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Không mất góc",
                                    style: getCustomTextStyle(
                                      fontSize: 12,
                                      color: kPrimaryTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/images/spotlight_icon.png',
                                      package: 'sample_sdk_flutter',
                                      width: 100),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Không lóa sáng",
                                    style: getCustomTextStyle(
                                      fontSize: 12,
                                      color: kPrimaryTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage(
                          "assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter',
                        ),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Giấy tờ chính chủ và còn hạn sử dụng.",
                        style: getCustomTextStyle(
                          fontSize: 12,
                          color: kPrimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage(
                          "assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter',
                        ),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Là ảnh gốc, không scan và photocopy.",
                        style: getCustomTextStyle(
                          fontSize: 12,
                          color: kPrimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage(
                          "assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter',
                        ),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Ảnh chụp rõ ràng, đủ góc cạnh, không bị loá mờ nhay thiếu sáng.",
                          style: getCustomTextStyle(
                            fontSize: 12,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: PrimaryButton(
                // padding: EdgeInsets.all()
                onPressed: !_initSuccess
                    ? null
                    : () {
                        // CardValidationScreen().launch(context);
                      },
                text: "Tiếp theo",
                color: Colors.white,
                backgroundColor: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buildPopupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              margin: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.08,
                  20,
                  MediaQuery.of(context).size.height * 0.08),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hướng dẫn xác thực danh tính",
                    style: getCustomTextStyle(
                      fontSize: 20,
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Các loại thẻ hợp lệ",
                          style: getCustomTextStyle(
                              fontSize: 17,
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Row contents vertically,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(9),
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/cccd_icon.png',
                                      package: 'sample_sdk_flutter', width: 60),
                                  SizedBox(height: 5),
                                  Text(
                                    "Căn cước \nCông dân",
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(9),
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/cmnd_icon.png',
                                      package: 'sample_sdk_flutter', width: 60),
                                  SizedBox(height: 5),
                                  Text(
                                    "Chứng minh \nNhân dân",
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(9),
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/passport_icon.png',
                                      package: 'sample_sdk_flutter', width: 35),
                                  SizedBox(height: 5),
                                  Text(
                                    "Hộ chiếu",
                                    style: getCustomTextStyle(
                                      fontSize: 15,
                                      color: kPrimaryTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Ảnh không hợp lệ",
                          style: getCustomTextStyle(
                              fontSize: 17,
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Row contents vertically,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/blur_icon.png',
                                      package: 'sample_sdk_flutter',
                                      width: 100),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Không chụp mờ",
                                    style: getCustomTextStyle(
                                      fontSize: 12,
                                      color: kPrimaryTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/images/cutting_edge_icon.png',
                                      package: 'sample_sdk_flutter',
                                      width: 100),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Không mất góc",
                                    style: getCustomTextStyle(
                                      fontSize: 12,
                                      color: kPrimaryTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/images/spotlight_icon.png',
                                      package: 'sample_sdk_flutter',
                                      width: 100),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Không lóa sáng",
                                    style: getCustomTextStyle(
                                      fontSize: 12,
                                      color: kPrimaryTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage(
                          "assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter',
                        ),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Giấy tờ chính chủ và còn hạn sử dụng.",
                        style: getCustomTextStyle(
                          fontSize: 12,
                          color: kPrimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage(
                          "assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter',
                        ),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Là ảnh gốc, không scan và photocopy.",
                        style: getCustomTextStyle(
                          fontSize: 12,
                          color: kPrimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage(
                          "assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter',
                        ),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Ảnh chụp rõ ràng, đủ góc cạnh, không bị loá mờ nhay thiếu sáng.",
                          style: getCustomTextStyle(
                            fontSize: 12,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onPressed: !_initSuccess
                        ? null
                        : () {
                            Navigator.pop(context);
                            // CardValidationScreen().launch(context);
                          },
                    text: "Tiếp theo",
                    color: Colors.white,
                    backgroundColor: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                    // fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _buildWaitingPopupDialog(BuildContext context, {String message = ""}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Container(
            height: 320,
            width: 290,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 20),
                const Text(
                  "Please waiting ...",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Text(
                  "Loading image",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      },
    );
  }
}

class _guideTitle extends StatelessWidget {
  const _guideTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Hướng dẫn xác thực danh tính",
              style: getCustomTextStyle(
                fontSize: 20,
                color: kPrimaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}

class _validaCardGuide extends StatelessWidget {
  const _validaCardGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 1,
      child: FittedBox(
        child: Column(
          children: <Widget>[
            Text(
              "Các loại thẻ hợp lệ",
              style: getCustomTextStyle(
                  fontSize: 17,
                  color: kPrimaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(9),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset('assets/images/cccd_icon.png',
                          package: 'sample_sdk_flutter', width: 60),
                      SizedBox(height: 5),
                      Text(
                        "Căn cước \nCông dân",
                        style: getCustomTextStyle(
                          fontSize: 15,
                          color: kPrimaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(9),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset('assets/images/cmnd_icon.png',
                          package: 'sample_sdk_flutter', width: 60),
                      SizedBox(height: 5),
                      Text(
                        "Chứng minh \nNhân dân",
                        style: getCustomTextStyle(
                          fontSize: 15,
                          color: kPrimaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(9),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset('assets/images/passport_icon.png',
                          package: 'sample_sdk_flutter', width: 35),
                      SizedBox(height: 5),
                      Text(
                        "Hộ chiếu",
                        style: getCustomTextStyle(
                          fontSize: 15,
                          color: kPrimaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _invalidCard extends StatelessWidget {
  const _invalidCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Ảnh không hợp lệ",
            style: getCustomTextStyle(
                fontSize: 17,
                color: kPrimaryTextColor,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            // crossAxisAlignment:
            //     CrossAxisAlignment., //Center Row contents vertically,
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.asset('assets/images/blur_icon.png',
                        package: 'sample_sdk_flutter', width: 100),
                    const SizedBox(height: 5),
                    Text(
                      "Không chụp mờ",
                      style: getCustomTextStyle(
                        fontSize: 12,
                        color: kPrimaryTextColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.asset('assets/images/cutting_edge_icon.png',
                        package: 'sample_sdk_flutter', width: 100),
                    const SizedBox(height: 5),
                    Text(
                      "Không mất góc",
                      style: getCustomTextStyle(
                        fontSize: 12,
                        color: kPrimaryTextColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    // Image.asset('assets/images/spotlight_icon.png', width: 100),
                    Image.asset("assets/images/spotlight_icon.png",
                        package: 'sample_sdk_flutter', width: 100),
                    const SizedBox(height: 5),
                    Text(
                      "Không lóa sáng",
                      style: getCustomTextStyle(
                        fontSize: 12,
                        color: kPrimaryTextColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _guideText extends StatelessWidget {
  const _guideText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: FittedBox(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const ImageIcon(
                  AssetImage(
                    "assets/images/tick_circle.png",
                    package: 'sample_sdk_flutter',
                  ),
                  color: kPrimaryGreen,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  "Giấy tờ chính chủ và còn hạn sử dụng.",
                  style: getCustomTextStyle(
                    fontSize: 12,
                    color: kPrimaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                const ImageIcon(
                  AssetImage(
                    "assets/images/tick_circle.png",
                    package: 'sample_sdk_flutter',
                  ),
                  color: kPrimaryGreen,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Text(
                  "Là ảnh gốc, không scan và photocopy.",
                  style: getCustomTextStyle(
                    fontSize: 12,
                    color: kPrimaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                const ImageIcon(
                  AssetImage(
                    "assets/images/tick_circle.png",
                    package: 'sample_sdk_flutter',
                  ),
                  color: kPrimaryGreen,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Ảnh chụp rõ ràng, đủ góc cạnh, không bị loá mờ nhay thiếu sáng.",
                    style: getCustomTextStyle(
                      fontSize: 12,
                      color: kPrimaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class CardValidationGuideScreen extends StatefulWidget {
//   const CardValidationGuideScreen({Key? key}) : super(key: key);

//   @override
//   State<CardValidationGuideScreen> createState() =>
//       _CardValidationGuideScreenState();
// }

// class _CardValidationGuideScreenState extends State<CardValidationGuideScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PrimaryAppBar(
//           appBar: AppBar(),
//           iconColor: Colors.white,
//           text: "Xác định danh tính"),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         const SizedBox(width: 10),
//                         Text(
//                           "Giấy tờ chính chủ và còn hạn sử dụng.",
//                           style: getCustomTextStyle(
//                             fontSize: 12,
//                             color: kPrimaryTextColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: <Widget>[
//                         const SizedBox(width: 10),
//                         Text(
//                           "Là ảnh gốc, không scan và photocopy.",
//                           style: getCustomTextStyle(
//                             fontSize: 12,
//                             color: kPrimaryTextColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: <Widget>[
//                         const SizedBox(width: 10),
//                         Text(
//                           "Ảnh chụp rõ ràng, đủ góc cạnh, không bị loá mờ\n nhay thiếu sáng..",
//                           style: getCustomTextStyle(
//                             fontSize: 12,
//                             color: kPrimaryTextColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
