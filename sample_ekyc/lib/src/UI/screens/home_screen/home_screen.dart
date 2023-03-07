import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/BLOC/local_auth/local_auth_bloc.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/dialogs/show_dialog_animations.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/authentication/authentication_bloc.dart';
import '../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../configs/languages/localization.dart';
import '../../../constants/hard_constants.dart';
import '../../../navigations/app_pages.dart';
import '../../../navigations/app_routes.dart';
import '../../designs/app_themes/app_assets_links.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';
import '../notification/notification_screen.dart';
import '../user_profile/user_profile_body.dart';
import 'widgets/button_home.dart';
import 'widgets/title_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc.add(UserRemoteGetListStatusContractEvent());
    AppBlocs.localAuthBloc.add(LocalAuthCheckBioStatusEvent(
        username: AppBlocs.authenticationBloc.cachedUsername));
    AppBlocs.authenticationBloc
        .add(AuthenticationAddFirebaseTokenDisableLocationEvent());
    AppBlocs.userRemoteBloc.add(UserRemoteGetListNotificationEvent());
    if (AppBlocs.authenticationBloc.firstLogin == 'true') {
      Future.delayed(
        Duration.zero,
        () {
          showDialogRequestPermissionLocaion(false);
        },
      );
    }
  }

  final List<Widget> _widgetOptions = [
    HomeBody(),
    NotificationScreen(),
    UserProfileBody(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(_selectedIndex == 1){
      AppBlocs.userRemoteBloc.add(UserRemoteGetListNotificationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      bottomNavigationBar: TitledBottomNavigationBar(
        height: 60,
        currentIndex: _selectedIndex,
        indicatorHeight: 2,
        onTap: (index) => _onItemTapped(index),
        reverse: false,
        curve: Curves.easeIn,
        items: [
          TitledNavigationBarItem(
            title: Text(StringKey.home.tr),
            icon: AppAssetsLinks.ic_home,
          ),
          TitledNavigationBarItem(
            title: Text(StringKey.notification.tr),
            icon: AppAssetsLinks.ic_notification,
          ),
          TitledNavigationBarItem(
            title: Text(StringKey.user.tr),
            icon: AppAssetsLinks.ic_user,
          ),
        ],
        activeColor: ColorsNeutral.Lv1,
        inactiveColor: Colors.blueGrey,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssetsLinks.background_home,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  String getCountNum(UserRemoteGetDoneData state) {
    try {
      return state.statusContract
          .where((element) => element.type == 1)
          .toList()
          .first
          .countNum
          .toString();
    } catch (e) {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: kToolbarHeight + (Platform.isIOS ? 70.px : 50.px)),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.px)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: ColorsGray.Lv3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(
                  StringKey.service.tr.toUpperCase(),
                  style: AppTextStyle.textStyle.s12().w700().cN5(),
                ),
                SizedBox(
                  height: 16,
                ),
                BlocBuilder<UserRemoteBloc, UserRemoteState>(
                  builder: (context, state) {
                    if (state is UserRemoteGetDoneData) {
                      return ButtonHome.round(
                        countNum: getCountNum(state),
                        title: StringKey.homeSign.tr,
                        icon: AppAssetsLinks.home_sign,
                        onTap: () {
                          AppNavigator.push(Routes.SIGN_CONTRACT);
                        },
                      );
                    }
                    return ButtonHome.round(
                      countNum: '0',
                      title: StringKey.homeSign.tr,
                      icon: AppAssetsLinks.home_sign,
                      onTap: () {
                        AppNavigator.push(Routes.SIGN_CONTRACT);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  StringKey.support.tr.toUpperCase(),
                  style: AppTextStyle.textStyle.s12().w700().cN5(),
                ),
                SizedBox(
                  height: 16,
                ),
                ButtonHome.round(
                  icon: AppAssetsLinks.home_qa,
                  title: StringKey.homeQandA.tr,
                  onTap: () {
                    AppNavigator.push(Routes.WEB_VIEW, arguments: {
                      'link': QNA_LINK,
                      'title': 'Câu hỏi thường gặp'
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                ButtonHome.round(
                  icon: AppAssetsLinks.home_call_support,
                  title: StringKey.homeCallSupport.tr,
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '$UNIT_PHONE',
                    );
                    await launchUrlString(launchUri.toString());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    elevation: 0.0,
    toolbarHeight: 65,
    backgroundColor: Colors.transparent,
    title: BlocBuilder<UserRemoteBloc, UserRemoteState>(
      builder: (context, state) {
        if (state is UserRemoteGetDoneData) {
          return Padding(
            padding: EdgeInsets.only(top: 12.px),
            child: Row(
              children: [
                Container(
                  height: 40.px,
                  width: 40.px,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      AppAssetsLinks.user_info,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.px,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        state.userResponseDataEntry.name ?? '',
                        style: AppTextStyle.textStyle.s16().w700().cW5(),
                        maxLines: 2,
                      ),
                      // SizedBox(
                      //   height: 2.px,
                      // ),
                      // Text(
                      //   state.userResponseDataEntry.identityNumber ?? '',
                      //   style: AppTextStyle.textStyle.s12().w700().cW5(),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(top: 12.px),
          child: Row(
            children: [
              Container(
                height: 40.px,
                width: 40.px,
                child: ClipOval(
                  child: SvgPicture.asset(
                    AppAssetsLinks.user_info,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10.px,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppBlocs.userRemoteBloc.userResponseDataEntry.name ?? '',
                      style: AppTextStyle.textStyle.s16().w700().cW5(),
                      maxLines: 2,
                    ),
                    // SizedBox(
                    //   height: 2.px,
                    // ),
                    // Text(
                    //   AppBlocs.userRemoteBloc.userResponseDataEntry.identityNumber ?? '',
                    //   style: AppTextStyle.textStyle.s12().w700().cW5(),
                    // )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
