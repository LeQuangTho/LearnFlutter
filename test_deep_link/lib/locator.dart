import 'package:get_it/get_it.dart';
import 'package:test_deep_link/dynamic_link_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DynamicLinkService());
}