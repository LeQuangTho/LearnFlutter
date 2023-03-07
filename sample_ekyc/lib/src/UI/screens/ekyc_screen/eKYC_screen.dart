import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sample_sdk_flutter/src/models/device_infor.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/api_helper.dart';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';
import 'package:sample_sdk_flutter/src/utils/server_error_code_handler.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../configs/application.dart';
import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../common_widgets/buttons/button_primary.dart';
import '../../common_widgets/dialogs/show_dialog_animations.dart';
import '../../designs/app_background.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/layouts/appbar_common.dart';
import '../../designs/sizer_custom/sizer.dart';

class EKYCScreen extends StatefulWidget {
  const EKYCScreen({Key? key}) : super(key: key);

  @override
  State<EKYCScreen> createState() => _EKYCScreenState();
}

class _EKYCScreenState extends State<EKYCScreen> {
   @override
  void initState() {   
    super.initState();
    print("generateSessionID widget.sdkConfig");

    initSdkConfig();
    startEkycSession();
  }

  void initSdkConfig() {
    if (AppData.sdkConfig == null) {
      print("generateSessionID widget.sdkConfig == null");
    }

    if (AppData.sdkConfig != null && !AppConfig.isInit) {
      AppConfig.isInit = true;
      AppConfig().source = AppData.sdkConfig!.source;
      AppConfig().apiUrl = AppData.sdkConfig!.apiUrl;
      AppConfig().token = AppData.sdkConfig!.token;
      AppConfig().timeOut = AppData.sdkConfig!.timeOut;
      AppConfig().email = AppData.sdkConfig!.email;
      AppConfig().phone = AppData.sdkConfig!.phone;
      AppConfig().backRoute = AppData.sdkConfig!.backRoute;
      // print("generateSessionID chen callback");
      AppConfig().sdkCallback = AppData.sdkConfig!.sdkCallback;
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

    showDialogLoading();
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
    } else {
      Navigator.pop(context);
      if (response.code == "TIMEOUT") {
        showToast(ToastType.error,
            title: getMessageFromErrorCode(response.code));
      } else {
        if (AppConfig().sdkCallback != null) {
          AppConfig().sdkCallback!.generateSessionID(
              false, response.code ??= "", response.error ??= "", "");
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BackgroundStack(
      child: Scaffold(
        appBar: MyAppBar(''),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.px),
                    Text(
                      'Hướng dẫn đăng ký',
                      style: AppTextStyle.textStyle.s30().w700().cN5(),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      'Theo quy định, để được cấp chứng thư số bạn cần cung cấp hồ sơ để chúng tôi tiến hành xác minh và thẩm định',
                      style: AppTextStyle.textStyle.s16().w400().cN4(),
                    ),
                    SizedBox(height: 30.px),
                    Text(
                      'Các bước đăng kí chứng thư số gồm:',
                      style: AppTextStyle.textStyle.s16().w500().cN5(),
                    ),
                    SizedBox(height: 8.px),
                    CreCtsGuideStep(
                      icon: AppAssetsLinks.identity_doc,
                      content:
                          'Chụp và quay video bản gốc CMND/CCCD/Hộ chiếu của Người sở hữu chứng thư số',
                    ),
                    SizedBox(height: 8.px),
                    CreCtsGuideStep(
                      icon: AppAssetsLinks.face,
                      content: 'Chụp và quay video khuôn mặt',
                    ),
                    SizedBox(height: 8.px),
                    CreCtsGuideStep(
                      icon: AppAssetsLinks.sign_cts,
                      content: 'Ký đơn đề nghị cấp chứng thư số',
                    ),
                    SizedBox(height: 8.px),
                    CreCtsGuideStep(
                      icon: AppAssetsLinks.check_cts,
                      content:
                          'Kiểm tra thông tin chứng thư số và quay video xác nhận',
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                content: 'Bắt đầu đăng ký',
                onTap: () {
                  if (AppBlocs.authenticationBloc.loginResponseData.userModel?.isEKYC == true) {
                    AppNavigator.push(Routes.VERIFY_OCR_METHOD);                   
                  } else {
                    AppNavigator.push(Routes.EKYC_VERIFY_PICTURE);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreCtsGuideStep extends StatelessWidget {
  const CreCtsGuideStep({
    Key? key,
    required this.icon,
    required this.content,
  }) : super(key: key);

  final String icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: 8.px),
        Expanded(
          child: Text(
            content,
            style: AppTextStyle.textStyle.s16().w400().cN5(),
          ),
        ),
      ],
    );
  }
}

appBar({
  String? title,
  Color? backgroundColor,
  Widget? leading,
  List<Widget>? action,
  double? leadingWidth,
  void Function()? onBack,
}) {
  return AppBar(
    leadingWidth: leadingWidth,
    backgroundColor: backgroundColor,
    title: title == null
        ? null
        : Padding(
            padding:
                EdgeInsets.only(right: ((action ?? []).isEmpty) ? 50.px : 0.px),
            child: Center(
              child: Text(
                title,
                style: AppTextStyle.textStyle.s16().w400().cW5(),
              ),
            ),
          ),
    elevation: 0.0,
    leading: leading ??
        InkWell(
          onTap: onBack ??
              () {
                AppNavigator.pop();
              },
          child: Padding(
            padding: EdgeInsets.only(left: 0.px),
            child: SvgPicture.asset(
              AppAssetsLinks.ic_arrow_left,
              color: ColorsNeutral.Lv5,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
    bottom: PreferredSize(
      child: Container(
        color: ColorsSupport.dividerColor,
        height: 1.px,
      ),
      preferredSize: Size.fromHeight(1.0),
    ),
    actions: action,
  );
}
