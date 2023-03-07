import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/models/response/notification_data.dart';
import '../../../../extentions/type_extesions.dart';
import '../../../../extentions/typedef.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/app_themes/app_colors.dart';
import '../../../designs/app_themes/app_text_styles.dart';
import '../../../designs/sizer_custom/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_html/flutter_html.dart';

import '../../../../helpers/time_ago.dart';

class ItemNotification extends StatelessWidget {
  const ItemNotification({
    Key? key,
    this.onTap,
    required this.data,
  }) : super(key: key);

  final Callback? onTap;
  final NotificationData data;

  Color _getColorNotificationType(NotificationType? type) {
    switch (type) {
      case NotificationType.THEM_MOI_HOP_DONG:
      case NotificationType.GIA_HAN_HOP_DONG:
        return ColorsBlue.Lv5;
      case NotificationType.KHONG_DUOC_DUYET:
        return ColorsPrimary.Lv5;
      case NotificationType.HOP_DONG_SAP_HET_HAN:
        return ColorsWarn.Lv5;
      case NotificationType.HOAN_THANH_KY:
      case NotificationType.PHAT_HANH_THE_THANH_CONG:
        return ColorsSuccess.Lv5;
      default:
        return ColorsBlue.Lv5;
    }
  }

  NotificationType _getEnumNotificationType() {
    return NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.' + data.notificationType!,
        orElse: () => NotificationType.NONE);
  }

  String _buildIcon() {
    switch (_getEnumNotificationType()) {
      case NotificationType.THEM_MOI_HOP_DONG:
      case NotificationType.GIA_HAN_HOP_DONG:
        return AppAssetsLinks.ic_pen_sign;
      case NotificationType.KHONG_DUOC_DUYET:
        return AppAssetsLinks.ic_contract_not_approved;
      case NotificationType.HOP_DONG_SAP_HET_HAN:
        return AppAssetsLinks.ic_contract_sign_expires;
      case NotificationType.HOAN_THANH_KY:
        return AppAssetsLinks.ic_contract_complete;
      case NotificationType.PHAT_HANH_THE_THANH_CONG:
        return AppAssetsLinks.ic_card_iss_success;
      default:
        return AppAssetsLinks.ic_profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('vi', VnMessages());
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
          decoration: BoxDecoration(
              color: data.isRead!
                  ? ColorsWhite.Lv1
                  : _getColorNotificationType(_getEnumNotificationType()),
              border: Border(bottom: BorderSide(color: ColorsGray.Lv2))),
          child: Row(
            children: [
              SvgPicture.asset(
                _buildIcon(),
                width: 24.px,
                height: 24.px,
              ),
              SizedBox(
                width: 8.px,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.title ?? '',
                            style: AppTextStyle.textStyle.s14().w700().cN5(),
                          ),
                        ),
                        Text(
                          timeago.format(DateTime.parse(data.createdDate ?? ''),
                              locale: 'vi'),
                          style: AppTextStyle.textStyle.s12().w600().cN5(),
                        )
                      ],
                    ),
                    Html(
                      data: data.content ?? '',
                      style: {
                        "p": Style(
                          fontSize: FontSize(12.px),
                          color: ColorsNeutral.Lv4,
                          fontWeight: FontWeight.w400,
                        ),
                        "body": Style(
                          padding: EdgeInsets.zero,
                          margin: Margins(
                            bottom: Margin.zero(),
                            left: Margin.zero(),
                            top: Margin.zero(),
                            right: Margin.zero(),
                          ),
                        )
                      },
                    ),
                    // Text(
                    //   data.content ?? '',
                    //   style: AppTextStyle.textStyle.s16().w400().cN4(),
                    // ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
