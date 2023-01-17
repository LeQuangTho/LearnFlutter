import '../app_helpers.dart';

class AppData {
  /// [Production - DEV]
  static const String mode = MODE_DEV;

  // Only for working in office
  factory AppData() {
    return _instance;
  }

  /// Singleton factory
  AppData._internal();
  static final AppData _instance = AppData._internal();
}