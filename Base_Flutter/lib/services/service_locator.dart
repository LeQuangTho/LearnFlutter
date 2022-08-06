import 'package:base_flutter/services/web_api/_api.dart';
import 'package:base_flutter/ui/views/home/home_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /// api
  locator.registerLazySingleton(() => Api());

  /// Service
  /// locator.registerLazySingleton(() => NavigatorService());

  /// View-Model
  locator.registerFactory(() => HomeModel());
}
