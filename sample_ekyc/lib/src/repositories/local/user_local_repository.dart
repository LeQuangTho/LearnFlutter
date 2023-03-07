import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hive/hive.dart';
import 'package:hdsaison_signing/src/constants/local_storage_keys.dart';

class UserLocalRepository {
  var box = Hive.box(LocalStorageKey.BOX_DOCTOR);
  Future<List<String>> getSupportedLocales() async {
    final List<String> _supportedLocales =
        await box.get(LocalStorageKey.LIST_LOCALES) ??
            [
              'en',
              'vi',
            ];
    return _supportedLocales;
  }

  Future<List<String>> getListSignature() async {
    final List<String> _listSignature =
        await box.get(AppBlocs.userRemoteBloc.userResponseDataEntry.id) ?? [];
    return _listSignature;
  }

  Future<String?> getName({required String username}) async {
    final String? name = await box.get(username);
    return name;
  }

  Future<String?> getRemmemberAccount() async {
    final String? remember =
        await box.get(LocalStorageKey.BOX_REMMEMBER_ACCOUT);
    return remember;
  }

  Future<Map<dynamic, dynamic>> getDeviceInfor() async {
    print(">>>>>>>>>>>>> ${await box.get(LocalStorageKey.DEVICE_INFOR)}");
    final Map<dynamic, dynamic> deviceInfo =
        await box.get(LocalStorageKey.DEVICE_INFOR);
    return deviceInfo;
  }

  Future<String> getCurrentLocale() async {
    final String currentLocale =
        box.get(LocalStorageKey.CURRENT_LOCALE) ?? 'vi';
    return currentLocale;
  }

  Future<String> getRegisterToken() async {
    final registerToken = await box.get(LocalStorageKey.REGISTER_TOKEN);
    return registerToken;
  }

  Future<String> getAccessToken() async {
    final accessToken = await box.get(LocalStorageKey.ACCESS_TOKEN);
    return accessToken;
  }

  // Future<String> getRefreshToken() async {
  //   final refreshToken = await box.get(LocalStorageKey.REFRESH_TOKEN);
  //   return refreshToken;
  // }

  Future<String> getExpireToken() async {
    final expire = await box.get(LocalStorageKey.ACCESS_TOKEN_EXPIRE);
    return expire;
  }

  Future<void> addSignature({
    required String base64,
  }) async {
    final List<String> _listSignature =
        await box.get(AppBlocs.userRemoteBloc.userResponseDataEntry.id) ?? [];
    _listSignature.add(base64);
    box.put(AppBlocs.userRemoteBloc.userResponseDataEntry.id, _listSignature);
  }

  Future<void> removeSignature({
    required String value,
  }) async {
    final List<String> _listSignature =
        await box.get(AppBlocs.userRemoteBloc.userResponseDataEntry.id) ?? [];
    _listSignature.remove(value);
    box.put(AppBlocs.userRemoteBloc.userResponseDataEntry.id, _listSignature);
  }

  Future<void> saveLocale({required String newLanguageCode}) async {
    box.put(LocalStorageKey.CURRENT_LOCALE, newLanguageCode);
  }

  void saveDeviceInfor(Map<dynamic, dynamic> map) async {
    box.put(LocalStorageKey.DEVICE_INFOR, map);
  }

  void saveAccessTokenExpire(String expire) async {
    box.put(LocalStorageKey.ACCESS_TOKEN_EXPIRE, expire);
  }

  void saveRegisterToken(String token) async {
    box.put(LocalStorageKey.REGISTER_TOKEN, token);
  }

  void saveAccessToken(String token) async {
    box.put(LocalStorageKey.ACCESS_TOKEN, token);
  }

  void saveBackupToken(String token) async {
    box.put(LocalStorageKey.BACKUP_TOKEN, token);
  }

  void saveRefreshToken(String token) async {
    box.put(LocalStorageKey.REFRESH_TOKEN, token);
  }

  void saveName({required String username, required String name}) async {
    box.put(username, name);
  }

  void savePassword(String password) async {
    box.put(LocalStorageKey.BOX_PASSWORD, password);
  }

  void saveRemmember(String remember) async {
    box.put(LocalStorageKey.BOX_REMMEMBER_ACCOUT, remember);
  }

  void clearRegisterToken() async {
    box.delete(LocalStorageKey.REGISTER_TOKEN);
  }

  void clearAccessToken() async {
    box.delete(LocalStorageKey.ACCESS_TOKEN);
  }

  void clearBackupToken() async {
    box.delete(LocalStorageKey.BACKUP_TOKEN);
  }

  void clearRefreshToken() async {
    box.delete(LocalStorageKey.REFRESH_TOKEN);
  }

  void clearName() async {
    box.delete(LocalStorageKey.BOX_NAME);
  }

  void clearPassword() async {
    box.delete(LocalStorageKey.BOX_PASSWORD);
  }

  void clearRemmember() async {
    box.delete(LocalStorageKey.BOX_REMMEMBER_ACCOUT);
  }

  void saveString({required String key, required String? value}) async {
    box.put(key, value);
  }

  Future<String> getString(
      {required String key, required String defaultValue}) async {
    final result = await box.get(key);
    return result ?? defaultValue;
  }

  void clearString({required String key}) async {
    box.delete(key);
  }
}
