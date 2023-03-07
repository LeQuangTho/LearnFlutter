import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/UI/common_widgets/loading/cover_loading.dart';
import 'package:hdsaison_signing/src/extentions/type_extesions.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../designs/app_themes/app_colors.dart';
import '../../designs/app_themes/app_text_styles.dart';
import '../../designs/sizer_custom/sizer.dart';
import 'widgets/item_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: kToolbarHeight + (Platform.isIOS ? 70.px : 50.px)),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.px)),
        child: Container(
          color: ColorsGray.Lv3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.px,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông báo mới',
                      style: AppTextStyle.textStyle.s16().w700().cN5(),
                    ),
                    BlocBuilder<UserRemoteBloc, UserRemoteState>(
                      builder: (context, state) {
                        if (state is UserRemoteGetDoneData) {
                          if (state.notifications.where((value) => value.isRead == false).toList().length !=0) {
                            return Container(
                              width: 20.px,
                              height: 20.px,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: ColorsGray.Lv2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  state.notifications.where((value) => value.isRead == false).toList().length.toString(),
                                  style: AppTextStyle.textStyle.s12().w700().cN5(),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16.px,
              ),
              Expanded(
                child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
                  builder: (context, state) {
                    if (state is UserRemoteGetDoneData) {
                      if (state.notifications.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 8.px,
                            children: state.notifications.map((e) {
                              int index = state.notifications.indexOf(e);
                              return ItemNotification(
                                onTap: () async {
                                  if (state.notifications[index].isRead == false) {
                                    AppBlocs.userRemoteBloc.add(
                                        UserRemoteReadNotificationEvent(
                                            notificationId: state.notifications[index].id ?? ''));
                                  }
                                  if (state.notifications[index].notificationType == NotificationType.PHAT_HANH_THE_THANH_CONG.name) {
                                    await launchUrl(Uri.parse(state.notifications[index].description ?? ''));
                                  } else {
                                    AppNavigator.push(Routes.DETAIL_CONTRACT,
                                        arguments: {
                                          "idDocument": state
                                              .notifications[index].referenceId,
                                          "nameDocument": state
                                              .notifications[index].description
                                        });
                                  }
                                },
                                data: state.notifications[index],
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'Không có thông báo nào',
                          style: AppTextStyle.textStyle.s16().w500().cN2(),
                        ),
                      );
                    }
                    return CoverLoading();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
