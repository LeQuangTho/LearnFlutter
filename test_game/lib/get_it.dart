import 'package:get_it/get_it.dart';
import 'package:test_game/fire_base_database.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<FireBaseDatabase>(FireBaseDatabase());
}
