import 'package:dating_now/src/core/app_dio/app_dio.dart';
import 'package:dating_now/src/core/bloc/app_blocs_provider.dart';
import 'package:dating_now/src/helpers/app_helpers.dart';
import 'package:dating_now/src/helpers/constants/app_data.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Manager Singleton in App
void setup() {
  getIt
    ..registerLazySingleton<AppDio>(AppDio.new)
    ..registerLazySingleton<AppBlocs>(AppBlocs.new)
    ..registerLazySingleton<AppData>(AppData.new)
    ..registerLazySingleton<UtilLogger>(UtilLogger.new);

  /// Initialize when using
  // getIt.registerFactory();
}
