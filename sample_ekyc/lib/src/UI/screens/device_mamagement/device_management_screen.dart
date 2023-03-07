import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/models/response/manager_device_response.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/user_remote_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/loading/cover_loading.dart';
import 'package:hdsaison_signing/src/helpers/date_time_helper.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/layouts/appbar_common.dart';
import '../../designs/sizer_custom/sizer.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({Key? key}) : super(key: key);

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc.add(UserRemoteGetListDeviceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsGray.Lv3,
      appBar: MyAppBar('Quản lý thiết bị'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 32.px, bottom: 16.px),
              child: SvgPicture.asset(AppAssetsLinks.monitor_mobile),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: Text(
                'Các thiết bị bạn đăng ký sử dụng Smart OTP',
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle.s16().w400().cN5(),
              ),
            ),
            BlocBuilder<UserRemoteBloc, UserRemoteState>(
              builder: (context, state) {
                if(state is UserRemoteGetDoneData){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.px,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.px),
                        child: Text(
                          'THIẾT BỊ ĐƯỢC TIN CẬY',
                          style: AppTextStyle.textStyle.s12().w600().cN5(),
                        ),
                      ),
                       SizedBox(height: 18.px,),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: state.listDevices.where((e) => e.isIdentifierDevice!).toList().length,
                        itemBuilder: (context, index) {
                          return  _buildItem(state.listDevices.where((e) => e.isIdentifierDevice!).toList()[0]);
                        },
                      ),
                      SizedBox(height: 16.px,),
                      Visibility(
                        visible: state.listDevices.where((e) => !e.isIdentifierDevice!).toList().isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.px),
                              child: Text(
                                'THIẾT BỊ KHÁC',
                                style: AppTextStyle.textStyle.s12().w600().cN5(),
                              ),
                            ),
                            SizedBox(height: 8.px,),
                            ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(height: 5.px,),
                              primary: false,
                              itemCount: state.listDevices.where((e) => !e.isIdentifierDevice!).toList().length,
                              itemBuilder: (context, index) {
                                return  _buildItem(state.listDevices.where((e) => !e.isIdentifierDevice!).toList()[index]);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return CoverLoading();
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _buildItem(DeviceDataEntry device) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.px,vertical: 5),
      decoration: BoxDecoration(
        color: ColorsLight.Lv1,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssetsLinks.ic_mobile,
            color: ColorsNeutral.Lv1,
          ),
          SizedBox(width: 20.px),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.deviceName!.toUpperCase(),
                  style: AppTextStyle.textStyle.s16().w700().cN5(),
                ),
                SizedBox(height: 5.px,),
                device.status! ? Text(
                  'Đang đăng nhập',
                  style: AppTextStyle.textStyle.s12().w400().cG5(),
                ) : Text(
                  'Đăng nhập lần cuối lúc ${dateTimeHHssDDmmYYYYFormat(device.lastLoginTime ?? '')}',
                  style: AppTextStyle.textStyle.s12().w400().cN3(),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showDialogConfirm(
                  title: "Hủy liên kết thiết bị",
                  body:
                  device.isIdentifierDevice! ? "Thông tin đăng nhập và cài đặt liên quan sẽ không tồn tại trên thiết bị. Ứng dụng sẽ tự động đăng xuất." :
                  "Thông tin đăng nhập và cài đặt liên quan sẽ không tồn tại trên thiết bị.",
                  action: () {
                    if(device.status == true){
                      AppBlocs.userRemoteBloc.add(UserRemoteGetCancelDeviceEvent(deviceId: device.deviceId ?? ''));
                      AppBlocs.authenticationBloc.add(AuthenticationLogOutCancelDeviceEvent());
                    }else{
                      AppBlocs.userRemoteBloc.add(UserRemoteGetCancelDeviceEvent(deviceId: device.deviceId ?? ''));
                    }
                  });
            },
            child: Text(
              'Hủy liên kết',
              style: AppTextStyle.textStyle.s12().w600().cP5(),
            ),
          ),
        ],
      ),
    );
  }
}
