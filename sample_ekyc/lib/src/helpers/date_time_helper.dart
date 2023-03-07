import 'package:intl/intl.dart';

String dateTimeFormat(String input) {
  final result = input.replaceAll('-', '/');
  return result;
}

String dateTimeFormat2(String input) {
  final result = input.substring(0, 10).split('-').reversed.join('-');
  return result;
}

String dateTimeFormat3(String input, [String format = 'dd/MM/yyyy']) {
  try {
    final result = DateFormat(format).format(DateTime.parse(input));
    return result;
  } catch (e) {
    return input;
  }
}

String dateTimeHHssDDmmYYYYFormat(String input) {
  try {
    final result =
        DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.parse(input));
    return result;
  } catch (e) {
    return input;
  }
}

String dateTimeFormat4(String input) {
  String formatResult = "HH:mm:ss - dd/MM/yyyy";
  try {
    final result =
        DateFormat(formatResult).format(DateTime.parse(input).toLocal());
    return result;
  } catch (e) {
    try {
      final result = DateFormat(formatResult).format(
          DateFormat('EEE MMM dd HH:mm:ss UTC yyyy')
              .parse(input, true)
              .toLocal());
      return result;
    } catch (e) {
      return input;
    }
  }
}
