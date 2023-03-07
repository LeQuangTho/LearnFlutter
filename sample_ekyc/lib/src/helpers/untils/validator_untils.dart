import '../../BLOC/app_blocs.dart';
import '../../configs/languages/localization.dart';

class ValidatorUtils {
  /// Checks if string is email.
  static bool isEmail(String s) => hasMatch(
      s, r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$');

  /// Checks if string is phone number.
  static bool isPhoneNumber(String s) {
    if (s.length != 10) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  static String? isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return StringKey.blankFieldErrorText.tr;
    }
    if (phoneNumber.length != 10 ||
        phoneNumber[0] != '0' ||
        int.tryParse(phoneNumber) == null) {
      return StringKey.invalidFormat.tr;
    }
    return null;
  }

  static bool isRepeatingNumber(String pinCode) {
    final String pattern = r'^(?!(\d)\1{5})\d{6}$';
    return !RegExp(pattern).hasMatch(pinCode);
  }

  static bool isSequential(String pinCode) {
    final String pattern =
        r'((?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)|9(?=0)){5}\d$|(?:0(?=9)|1(?=0)|2(?=1)|3(?=2)|4(?=3)|5(?=4)|6(?=5)|7(?=6)|8(?=7)|9(?=8)){5}\d$)';
    return RegExp(pattern).hasMatch(pinCode);
  }

  static String? isValidPINcode(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return '';
    }
    if (phoneNumber.length != 4 || int.tryParse(phoneNumber) == null) {
      return '';
    }
    return null;
  }

  static String? isValidEmail(String? email) {
    if (email == null || email.isEmpty) {
      return StringKey.blankFieldErrorText.tr;
    } else {
      if (!ValidatorUtils.isEmail(email.toString())) {
        return StringKey.cannotFindEmailErrorText.tr;
      }
    }
    return null;
  }

  static bool isPasswordLengthValidated(String password) {
    RegExp regex = RegExp(r'^.{8,20}$');
    return regex.hasMatch(password);
  }

  static bool isPasswordContainAnUperCase(String password) {
    RegExp regex = RegExp(r'^(?=.*[A-Z]).{1,}$');
    return regex.hasMatch(password);
  }

  static bool isPasswordContainALowercase(String password) {
    RegExp regex = RegExp(r'^(?=.*[a-z]).{1,}$');
    return regex.hasMatch(password);
  }

  static bool isPasswordContainANumberic(String password) {
    RegExp regex = RegExp(r'^(?=.*[0-9]).{1,}$');
    return regex.hasMatch(password);
  }

  static bool isPasswordContainASpecialCharacter(String password) {
    RegExp regex = RegExp(r'^(?=.*[!@#$%^&*()\-_+=.,]).{1,}$');
    return regex.hasMatch(password);
  }

  static String? isValidateCertificateNumber(String? number) {
    if (number == null || number.isEmpty) {
      return StringKey.blankFieldErrorText.tr;
    }
    if (number.length != 6) {
      return StringKey.invalidFormat.tr;
    }
    return null;
  }

  /// Checks if string is DateTime (UTC or Iso8601).
  static bool isDateTime(String s) =>
      hasMatch(s, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  // static String? checkStartEndTime(String? value) {
  //   if (value == null) {
  //     return null;
  //   }
  //   List<String> values = value.split(' - ');
  //   TimeOfDay startTime = TimeOfDay(
  //     hour: int.parse(values[0].split(':')[0]),
  //     minute: int.parse(
  //       values[0].split(':')[1],
  //     ),
  //   );
  //   TimeOfDay endTime = TimeOfDay(
  //     hour: int.parse(values[1].split(':')[0]),
  //     minute: int.parse(
  //       values[1].split(':')[1],
  //     ),
  //   );

  //   if (startTime.hour == endTime.hour && startTime.minute == endTime.minute) {
  //     return Strings.invalid.i18n;
  //   } else if (endTime.hour == 0 && endTime.minute == 0) {
  //     return null;
  //   } else if ((endTime.hour == startTime.hour && endTime.minute < startTime.minute) || (endTime.hour < startTime.hour)) {
  //     return Strings.invalid.i18n;
  //   }
  //   return null;
  // }

  ///Check if the id is valid id card number<Visa/Mastercard> flow by Luhn algorithm
  ///[value] is the id card number.
  ///The method returns true if the id card number is valid and false if invalid.

  static bool isValidCardNumber(String value) {
    String clean = value.replaceAll(new RegExp(r'\s'), '');
    if (clean.length <= 1 || clean.contains(new RegExp(r'\D'))) {
      return false;
    }
    int sum = 0;
    clean
        .split('')
        .reversed
        .map(int.parse)
        .toList()
        .asMap()
        .forEach((index, number) {
      int b = index.isOdd ? number * 2 : number;
      sum += b > 9 ? b - 9 : b;
    });
    return sum % 10 == 0;
  }

  static bool hasInfoCreateCTS() {
    final String email =
        AppBlocs.userRemoteBloc.userResponseDataEntry.email ?? '';
    final String addr =
        AppBlocs.userRemoteBloc.userResponseDataEntry.address ?? '';
    return email.isNotEmpty && addr.isNotEmpty;
  }
}
