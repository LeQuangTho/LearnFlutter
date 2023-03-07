// Package imports:
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PreviousScreen {
  SignUp,
  SignContract,
  LoginOldCustomer,
}

enum ContractType {
  ALL,
  NOT_SIGNED,
  APPROVING,
  CANCELLED,
  DISBUSEMENT,
}

enum GenCertType {
  PKI_FUNC_ID_AUTH,
  PKI_FUNC_ID_V_MESSAGE,
}

enum ScreenPhase {
  FrontSide,
  BackSide,
}

enum AccountStatus {
  NOT_SIGNED_NOT_ACTIVATED,
  SIGNED_NOT_ACTIVATED,
  SINGED_ACTIVATING,
  SINGED_ACTIVATED,
}

enum CTSStatus {
  ACTIVE,
  EXPIRED,
}

enum ContractStatus {
  SIGNED,
  REJECTED,
  NOTSIGNED,
}

enum CreateContractType {
  ACCOUNT,
  CARD,
  CARD_LIMIT,
  INSURANCE,
  CAR_INSURANCE,
}

enum NotificationType {
  NONE,
  THEM_MOI_HOP_DONG,
  KHONG_DUOC_DUYET,
  GIA_HAN_HOP_DONG,
  HOP_DONG_SAP_HET_HAN,
  PHAT_HANH_THE_THANH_CONG,
  HOAN_THANH_KY
}

extension TextHeightCustem on Text {
  Text commonTextHeight() {
    return Text(
      data ?? '',
      style: style,
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: false,
        leadingDistribution: TextLeadingDistribution.even,
      ),
    );
  }
}

extension CurrencyProperty on String {
  String get formatCurrency {
    final int _number = int.parse(replaceAll('.', ''));
    if (_number > -1000 && _number < 1000) {
      return _number.toString();
    }

    final String digits = _number.abs().toString();
    final StringBuffer result = StringBuffer(_number < 0 ? '-' : '');
    final int maxDigitIndex = digits.length - 1;
    for (int i = 0; i <= maxDigitIndex; i += 1) {
      result.write(digits[i]);
      if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) {
        result.write('.');
      }
    }
    return result.toString();
  }

  String getInitialPerson() {
    if (isNotEmpty) {
      return trim().split(' ').map((l) => l[0]).take(2).join();
    } else {
      return '';
    }
  }

  String get convertCommaToDot {
    return replaceAll(',', '.');
  }

  String get removeCurrency {
    return replaceAll('.', '').replaceAll(' ', '').replaceAll(',', '');
  }

  String get phoneFormat {
    // ignore: always_put_control_body_on_new_line
    if (isEmpty) return '';
    final money = double.parse(replaceAll(' ', ''));
    final format = NumberFormat('###,###,###');
    return format.format(money);
  }

  String get removeSpace {
    if (isEmpty) {
      return '';
    }

    return replaceAll(RegExp(r'\s+'), '');
  }
}

extension ConvertStatus on int {
  ContractType getContractType() {
    switch (this) {
      case 1:
        return ContractType.APPROVING;
      case 3:
        return ContractType.DISBUSEMENT;
      case 2:
        return ContractType.CANCELLED;
      case 0:
        return ContractType.NOT_SIGNED;
      default:
        return ContractType.ALL;
    }
  }
}

extension DateConvert on int {
  String get toIntMonth {
    switch (this) {
      case 1:
        return '01';
      case 2:
        return '02';
      case 3:
        return '03';
      case 4:
        return '04';
      case 5:
        return '05';
      case 6:
        return '06';
      case 7:
        return '07';
      case 8:
        return '08';
      case 9:
        return '09';
      case 10:
        return '10';
      case 11:
        return '11';
      case 12:
        return '12';
      default:
        return '00';
    }
  }

  String get toIntDate {
    switch (this) {
      case 1:
        return '01';
      case 2:
        return '02';
      case 3:
        return '03';
      case 4:
        return '04';
      case 5:
        return '05';
      case 6:
        return '06';
      case 7:
        return '07';
      case 8:
        return '08';
      case 9:
        return '09';
      default:
        return toString();
    }
  }
}

extension DateTimeFormat on String {
  String formatDateTime() {
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(this)).toString();
    return formattedDate;
  }
}

extension CutString on String {
  String cutString({required String type}) {
    try {
      return this
          .split(',')
          .toList()
          .firstWhere((e) => e.contains(type))
          .replaceAll(type, '');
    } catch (e) {
      return '';
    }
  }
}
