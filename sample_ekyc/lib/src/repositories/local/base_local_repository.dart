import 'package:hive/hive.dart';
import 'package:hdsaison_signing/src/constants/local_storage_keys.dart';

import '../../helpers/path_helpers.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    var path = await PathHelper.appDir;
    Hive..init(path.path);
    await Hive.openBox(LocalStorageKey.BOX_DOCTOR);
  }
}
