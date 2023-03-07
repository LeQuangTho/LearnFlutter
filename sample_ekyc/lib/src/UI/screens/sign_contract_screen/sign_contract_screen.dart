import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/models/response/contract_item_response.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_assets_links.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_colors.dart';
import 'package:hdsaison_signing/src/UI/designs/app_themes/app_text_styles.dart';
import 'package:hdsaison_signing/src/UI/designs/layouts/appbar_common.dart';
import 'package:hdsaison_signing/src/UI/designs/sizer_custom/sizer.dart';
import 'package:hdsaison_signing/src/extentions/typedef.dart';
import 'package:hdsaison_signing/src/helpers/date_time_helper.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../BLOC/app_blocs.dart';
import '../../../BLOC/user_remote/models/response/contract_status_response.dart';
import '../../../BLOC/user_remote/user_remote_bloc.dart';
import '../../common_widgets/loading/cover_loading.dart';

class SignContractScreen extends StatefulWidget {
  const SignContractScreen({Key? key}) : super(key: key);

  @override
  State<SignContractScreen> createState() => _SignContractScreenState();
}

class _SignContractScreenState extends State<SignContractScreen> {
  List<ContractItemResponseDataEntry> list = [];
  List<StatusContract> status = [];
  int _typeSelected = 1;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  /// 1: Chờ ký
  /// 2: Đã từ chối
  /// 3: Đã hoàn thành
  /// 4: Chờ phê duyệt

  ScrollController _scrollController = ScrollController();
  int pageSize = 20;
  int pageNumber = 1;

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    list = [];
    AppBlocs.userRemoteBloc.add(UserRemoteGetListStatusContractEvent());
    AppBlocs.userRemoteBloc.add(UserRemoteGetListContractsEvent(
        type: 1, pageSize: pageSize, pageNumber: pageNumber));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        pageSize += 20;
        AppBlocs.userRemoteBloc.add(UserRemoteGetListContractsEvent(
            type: _typeSelected, pageSize: pageSize, pageNumber: pageNumber));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Danh sách hợp đồng'),
      backgroundColor: ColorsGray.Lv3,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 65.px,
            color: ColorsLight.Lv1,
            child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
              builder: (context, state) {
                if (state is UserRemoteGetDoneData) {
                  if (state.statusContract.isNotEmpty) {
                    status = state.statusContract;
                  }
                  return ScrollablePositionedList.separated(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.px, vertical: 15.px),
                    separatorBuilder: (_, i) => SizedBox(width: 8.px),
                    itemCount: status.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return itemStatus(
                        title: status[index].title ?? '',
                        type: status[index].type?.toInt() ?? 0,
                        countNum: status[index].countNum.toString(),
                        index: index,
                      );
                    },
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                  );
                }
                return ScrollablePositionedList.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.px, vertical: 15.px),
                  separatorBuilder: (_, i) => SizedBox(width: 8.px),
                  itemCount: status.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return itemStatus(
                      title: status[index].title ?? '',
                      type: status[index].type?.toInt() ?? 0,
                      countNum: status[index].countNum.toString(),
                      index: index,
                    );
                  },
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<UserRemoteBloc, UserRemoteState>(
              builder: (context, state) {
                if (state is UserRemoteGetDoneData) {
                  if (list.length != 0 &&
                      state.contractResponseData.data != null) {
                    list = [];
                    list.addAll(state.contractResponseData.data ?? []);
                  } else {
                    list.addAll(state.contractResponseData.data ?? []);
                  }
                  return list.isEmpty
                      ? Center(
                          child: Text(
                            'Danh sách hiện đang trống',
                            style: AppTextStyle.textStyle.s16().w500().cN2(),
                          ),
                        )
                      : SmartRefresher(
                          controller: _refreshController,
                          onRefresh: () => reloadData(),
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
                            separatorBuilder: (c, i) => SizedBox(height: 8),
                            itemBuilder: (c, i) => ItemContract(
                              docName: list[i].documentName,
                              time: list[i].documentStatus == '1'
                                  ? list[i].signExpireAtDate
                                  : list[i].modifiedDate,
                              soHD: list[i].document3rdId,
                              onTap: () async {
                                await AppNavigator.push(Routes.DETAIL_CONTRACT,
                                    arguments: {
                                      "idDocument": list[i].documentId,
                                      "nameDocument": list[i].documentName
                                    });
                                reloadData();
                              },
                            ),
                            itemCount: list.length,
                          ),
                        );
                }
                if (list.isEmpty) {
                  return CoverLoading();
                } else {
                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: () => reloadData(),
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
                      separatorBuilder: (c, i) => SizedBox(height: 8),
                      itemBuilder: (c, i) => ItemContract(
                        docName: list[i].documentName,
                        time: list[i].documentStatus == '1'
                            ? list[i].signExpireAtDate
                            : list[i].modifiedDate,
                        soHD: list[i].document3rdId,
                        onTap: () async {
                          await AppNavigator.push(Routes.DETAIL_CONTRACT,
                              arguments: {
                                "idDocument": list[i].documentId,
                                "nameDocument": list[i].documentName
                              });
                          reloadData();
                        },
                      ),
                      itemCount: list.length,
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future reloadData() async {
    AppBlocs.userRemoteBloc.add(UserRemoteGetListContractsEvent(
        type: _typeSelected, pageSize: pageSize, pageNumber: pageNumber));
    AppBlocs.userRemoteBloc.add(UserRemoteGetListStatusContractEvent());
    _refreshController.refreshCompleted();
  }

  Widget itemStatus(
      {required String title,
      required int type,
      String? countNum,
      required int index}) {
    return InkWell(
      onTap: () {
        list = [];
        _typeSelected = type;
        pageSize = 20;
        itemScrollController.scrollTo(
            index: index == 0 ? index : index - 1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic);
        AppBlocs.userRemoteBloc.add(UserRemoteGetListContractsEvent(
            type: type, pageSize: pageSize, pageNumber: pageNumber));
        setState(() {});
      },
      child: Container(
        height: 35.px,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.px),
            color: _typeSelected == type ? ColorsPrimary.Lv1 : ColorsLight.Lv1,
            border: _typeSelected == type
                ? null
                : Border.all(color: ColorsGray.Lv2)),
        child: Row(
          children: [
            Text(
              title,
              style: _typeSelected == type
                  ? AppTextStyle.textStyle.s12().w700().cW5()
                  : AppTextStyle.textStyle.s12().w700().cN2(),
            ),
            if (countNum != null && countNum != '0')
              Padding(
                padding: EdgeInsets.only(left: 8.px),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.px),
                    color: _typeSelected == type
                        ? ColorsLight.Lv1
                        : ColorsGray.Lv3,
                  ),
                  child: Center(
                    child: Text(
                      countNum,
                      style: _typeSelected == type
                          ? AppTextStyle.textStyle.s12().w700().cP5()
                          : AppTextStyle.textStyle.s12().w700().cN2(),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ItemContract extends StatelessWidget {
  const ItemContract(
      {Key? key, required this.onTap, this.docName, this.soHD, this.time})
      : super(key: key);
  final Callback onTap;
  final String? docName;
  final String? soHD;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.px),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.px),
              color: ColorsLight.Lv1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docName ?? '',
                  style: AppTextStyle.textStyle.s16().w700().cN5(),
                ),
                SizedBox(
                  height: 15.px,
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(AppAssetsLinks.timer),
                //           Expanded(
                //             child: Text(
                //               ' ${dateTimeHHssDDmmYYYYFormat(time ?? '')}',
                //               style: AppTextStyle.textStyle.s12().w500().cP3(),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //
                //   ],
                // )
              ],
            ),
          ),
        ),
        Positioned(
          right: 15,
          bottom: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(AppAssetsLinks.ic_so_hd),
              const SizedBox(
                width: 5,
              ),
              Text(
                soHD ?? '',
                style: AppTextStyle.textStyle.s12().w400().cN4(),
              )
            ],
          ),
        ),
        Positioned(
          left: 15,
          bottom: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssetsLinks.timer),
              Text(
                ' ${dateTimeHHssDDmmYYYYFormat(time ?? '')}',
                style: AppTextStyle.textStyle.s12().w500().cP3(),
              )
            ],
          ),
        )
      ],
    );
  }
}
