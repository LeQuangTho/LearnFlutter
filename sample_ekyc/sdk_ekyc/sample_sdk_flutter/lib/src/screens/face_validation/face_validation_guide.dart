import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import 'package:sample_sdk_flutter/src/screens/face_validation/face_validation_screen.dart';
import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:sample_sdk_flutter/src/components/primary_button.dart';
import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/components/custom_text_style.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';

class FaceValidateGuide extends StatefulWidget {
  SdkConfig? sdkConfig;
  FaceValidateGuide({required this.sdkConfig, Key? key}) : super(key: key);

  @override
  State<FaceValidateGuide> createState() => _FaceValidateGuideState();
}

class _FaceValidateGuideState extends State<FaceValidateGuide> {
  bool _isCallingApi = false;
  bool _initSuccess = false;

  @override
  void initState() {
    super.initState();
    initSdkConfig();
  }

  void initSdkConfig() {
    if (widget.sdkConfig != null && !AppConfig.isInit) {
      AppConfig.isInit = true;
      AppConfig().source = widget.sdkConfig!.source;
      AppConfig().apiUrl = widget.sdkConfig!.apiUrl;
      AppConfig().token = widget.sdkConfig!.token;
      AppConfig().timeOut = widget.sdkConfig!.timeOut;
      AppConfig().email = widget.sdkConfig!.email;
      AppConfig().phone = widget.sdkConfig!.phone;
      AppConfig().backRoute = widget.sdkConfig!.backRoute;
      AppConfig().sdkCallback = widget.sdkConfig!.sdkCallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getFaceValidationGuidelineBody(context);
  }

  Widget _getFaceValidationGuidelineDialog(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future.delayed(Duration.zero, () => _buildPopupDialog(context));
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: size.height,
      width: double.infinity,
    ));
  }

  Widget _getFaceValidationGuidelineBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: PrimaryAppBar(
          appBar: AppBar(),
          iconColor: Colors.white,
          text: "Xác định danh tính"),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hướng dẫn quay video khuôn mặt",
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
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Image.asset('assets/images/face_guide_icon.png',
                      package: 'sample_sdk_flutter'),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    const ImageIcon(
                      AssetImage("assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter'),
                      color: kPrimaryGreen,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Đảm bảo khuôn mặt ở trong khung hình.",
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
                      AssetImage("assets/images/tick_circle.png",
                          package: 'sample_sdk_flutter'),
                      color: kPrimaryGreen,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Thực hiện di chuyển khuôn mặt theo hướng dẫn.",
                        style: getCustomTextStyle(
                          fontSize: 12,
                          color: kPrimaryTextColor,
                        ),
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
                      AssetImage("assets/images/warning_2_icon.png",
                          package: 'sample_sdk_flutter'),
                      color: kPrimaryRed,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Không đeo kính, đội mũ, đeo khẩu trang hoặc trùm tóc khi chụp ảnh",
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
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => FaceValidationScreen(),
                );
                Navigator.push(context, route);
              },
              text: "Tiếp theo",
              color: Colors.white,
              backgroundColor: kPrimaryColor,
              borderRadius: BorderRadius.circular(8),
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]),
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
                    "Hướng dẫn quay video khuôn mặt",
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
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Image.asset(
                      'assets/images/face_guide_icon.png',
                      package: 'sample_sdk_flutter',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      const ImageIcon(
                        AssetImage("assets/images/tick_circle.png",
                            package: 'sample_sdk_flutter'),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Đảm bảo khuôn mặt ở trong khung hình.",
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
                        AssetImage("assets/images/tick_circle.png",
                            package: 'sample_sdk_flutter'),
                        color: kPrimaryGreen,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Thực hiện di chuyển khuôn mặt theo hướng dẫn.",
                          style: getCustomTextStyle(
                            fontSize: 12,
                            color: kPrimaryTextColor,
                          ),
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
                        AssetImage("assets/images/warning_2_icon.png",
                            package: 'sample_sdk_flutter'),
                        color: kPrimaryRed,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Không đeo kính, đội mũ, đeo khẩu trang hoặc trùm tóc khi chụp ảnh",
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
                    onPressed: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (context) => FaceValidationScreen(),
                      );
                      Navigator.push(context, route);
                    },
                    text: "Tiếp theo",
                    color: Colors.white,
                    backgroundColor: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
