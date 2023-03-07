import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../../../extentions/typedef.dart';
import '../../../../helpers/date_time_helper.dart';
import '../../../common_widgets/loading/cover_loading.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/layouts/appbar_common.dart';
import '../../../designs/sizer_custom/sizer.dart';
import '../widgets/edit_address.dart';
import '../widgets/edit_date_of_birth.dart';
import '../widgets/edit_email.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  void initState() {
    super.initState();
    AppBlocs.userRemoteBloc.add(UserRemoteGetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Thông tin cá nhân'),
      backgroundColor: ColorsGray.Lv3,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is UserRemoteGetDoneData) {
              final userDetail = state.userResponseDataEntry;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 24.px,
                    ),
                    GestureDetector(
                      onTap: () {
                        // showModalBottomSheet(
                        //     context: context,
                        //     builder: (builder) {
                        //       return Padding(
                        //         padding: const EdgeInsets.all(20),
                        //         child: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             InkWell(
                        //               onTap: () {},
                        //               child: Row(
                        //                 children: [
                        //                   SvgPicture.asset(
                        //                       AppAssetsLinks.upload),
                        //                   SizedBox(
                        //                     width: 12,
                        //                   ),
                        //                   Text(
                        //                     'Tải ảnh lên',
                        //                     style: AppTextStyle.textStyle
                        //                         .s16()
                        //                         .w500()
                        //                         .cN5(),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 20,
                        //             ),
                        //             InkWell(
                        //               onTap: () {},
                        //               child: Row(
                        //                 children: [
                        //                   SvgPicture.asset(
                        //                       AppAssetsLinks.camera),
                        //                   SizedBox(
                        //                     width: 12,
                        //                   ),
                        //                   Text(
                        //                     'Chụp ảnh',
                        //                     style: AppTextStyle.textStyle
                        //                         .s16()
                        //                         .w500()
                        //                         .cN5(),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     });
                      },
                      child: Center(
                        child: ClipOval(
                          child: SvgPicture.asset(
                            AppAssetsLinks.user_info,
                            fit: BoxFit.cover,
                            height: 56.px,
                            width: 56.px,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(
                      userDetail.name ?? '',
                      style: AppTextStyle.textStyle.s16().w700().cN5(),
                    ),
                    SizedBox(
                      height: 4.px,
                    ),
                    // Text(
                    //   (userDetail.identityNumber ?? '').replaceAll(RegExp(r'\d(?!\d{0,2}$)'), '*'),
                    //   style: AppTextStyle.textStyle.s12().w600().cN2(),
                    // ),
                    SizedBox(
                      height: 16.px,
                    ),
                    ContainerInfo(
                      list: [
                        Text(
                          'Thông tin cá nhân',
                          style: AppTextStyle.textStyle.s16().w700().cN5(),
                        ),
                        InfoField.first(
                          title: 'Họ và tên',
                          content: userDetail.name ?? '',
                        ),
                        InfoField(
                          title: 'Số CMND/CCCD/HC',
                          content: (userDetail.identityNumber ?? '').replaceAll(RegExp(r'\d(?!\d{0,3}$)'), '*'),
                        ),
                        InfoField(
                          title: 'Ngày sinh',
                          content: dateTimeFormat3(userDetail.birthday ?? ''),
                          showEdit: false,
                          onTapEdit: () {
                            showDialog(
                              context: context,
                              builder: (builder) {
                                return EditDateOfBirth();
                              },
                            );
                          },
                        ),
                        InfoField(
                          title: 'Địa chỉ thường trú',
                          content: userDetail.permanentAddress,
                        ),
                        // InfoField(
                        //   title: 'Nơi cấp',
                        //   content: userDetail.placeOfOrigin,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 16.px,
                    ),
                    ContainerInfo(
                      list: [
                        Text(
                          'Thông tin liên lạc',
                          style: AppTextStyle.textStyle.s16().w700().cN5(),
                        ),
                        InfoField.first(
                          title: 'Số điện thoại cá nhân',
                          content: (userDetail.phoneNumber ?? '').replaceAll(RegExp(r'\d(?!\d{0,2}$)'), '*'),
                        ),
                        InfoField(
                          title: 'Email',
                          content: userDetail.email,
                          showEdit: true,
                          onTapEdit: () {
                            showDialog(
                              context: context,
                              builder: (builder) {
                                return EditEmail();
                              },
                            );
                          },
                        ),
                        InfoField(
                          title: 'Địa chỉ hiện tại',
                          content: userDetail.address,
                          showEdit: true,
                          onTapEdit: () {
                            showDialog(
                              context: context,
                              builder: (builder) {
                                return EditAddress();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              );
            }
            return CoverLoading();
          },
        ),
      ),
    );
  }
}

class ContainerInfo extends StatelessWidget {
  const ContainerInfo({
    Key? key,
    required this.list,
  }) : super(key: key);
  final List<Widget> list;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: ColorsLight.Lv1,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15), //color of shadow
            spreadRadius: 0, //spread radius
            blurRadius: 2, // blur radius
            offset: Offset(0, 2), // changes position of shadow
            //first paramerter of offset is left-right
            //second parameter is top to down
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  const InfoField({
    Key? key,
    required this.title,
    this.content,
    this.first = false,
    this.onTapEdit,
    this.showEdit = false,
  }) : super(key: key);

  InfoField.first({
    Key? key,
    required this.title,
    this.content,
    this.first = false,
    this.onTapEdit,
    this.showEdit = false,
  });
  final String title;
  final String? content;
  final bool first;
  final Callback? onTapEdit;
  final bool showEdit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!first) SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyle.textStyle.s12().w600().cN2(),
              ),
              SizedBox(
                height: 4.px,
              ),
              Text(
                content ?? '',
                style: AppTextStyle.textStyle.s16().w500().cN5(),
              ),
            ],
          ),
        ),
        if (showEdit)
          Column(
            children: [
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: onTapEdit,
                child: SvgPicture.asset(
                  AppAssetsLinks.ic_edit2,
                  height: 16,
                ),
              ),
            ],
          )
      ],
    );
  }
}
