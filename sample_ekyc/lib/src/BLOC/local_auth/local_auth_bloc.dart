import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../navigations/app_pages.dart';
import '../../repositories/local/local_auth_repository.dart';
import '../app_blocs.dart';
import '../authentication/authentication_bloc.dart';

part 'local_auth_event.dart';
part 'local_auth_state.dart';

class LocalAuthBloc extends Bloc<LocalAuthEvent, LocalAuthState> {
  List<BiometricType> biometricTypes = [];
  BiometricAccount account = BiometricAccount.empty;

  String cachedBioUsername = '';
  String cachedBioPassword = '';

  LocalAuthBloc() : super(LocalAuthInitial()) {
    on<LocalAuthGetBiometricTypesSupportEvent>(_onGetBiometricTypesSupport);
    on<LocalAuthActiveBiometricEvent>(_onActiveBiometric);
    on<LocalAuthCheckAccountIsActiveBiometricEvent>(
        _onCheckAccountIsActiveBiometric);
    on<LocalAuthDisableBiometricEvent>(_onDisableBiometric);
    on<LocalAuthDisableBiometricNoAuthenEvent>(_onDisableBiometricNoAuthen);
    on<LocalAuthBiometricLoginEvent>(_onBiometricLogin);
    on<LocalAuthCheckBioStatusEvent>(_onCheckBioStatus);
    on<LocalAuthCleanCachedDataEvent>(_onCleanCachedData);
  }

  void _onGetBiometricTypesSupport(
    LocalAuthGetBiometricTypesSupportEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    await getBiometricTypes();
    if (biometricTypes.isNotEmpty) {
      // yield UserPrivateInitial();
      emit(_unAuthenticatedBio);
    } else {
      emit(LocalAuthInitial());
    }
  }

  void _onActiveBiometric(
    LocalAuthActiveBiometricEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    if (await activeBiometric(
        username: event.username, password: event.password)) {
      emit(_authenticatedBio);
    } else {
      emit(_unAuthenticatedBio);
    }
  }

  void _onCheckAccountIsActiveBiometric(
    LocalAuthCheckAccountIsActiveBiometricEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    if (await checkIsActiveBiometricAccount(username: cachedBioUsername)) {
      emit(_authenticatedBio);
    } else {
      emit(_unAuthenticatedBio);
    }
  }

  void _onDisableBiometric(
    LocalAuthDisableBiometricEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    showDialogBio(
        title: 'Tắt tính năng đăng nhập bằng ' +
            ((AppBlocs.localAuthBloc.biometricTypes.isNotEmpty &&
                    AppBlocs.localAuthBloc.biometricTypes
                        .contains(BiometricType.face))
                ? "Face ID"
                : "Touch ID"),
        body: 'Vui lòng sử dụng ' +
            ((AppBlocs.localAuthBloc.biometricTypes.isNotEmpty &&
                    AppBlocs.localAuthBloc.biometricTypes
                        .contains(BiometricType.face))
                ? "Face ID"
                : "Touch ID") +
            ' để xác nhận');
    if (await disableBiometric(username: event.username)) {
      emit(_unAuthenticatedBio);
    } else {
      emit(_authenticatedBio);
    }
  }

  void _onDisableBiometricNoAuthen(
    LocalAuthDisableBiometricNoAuthenEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    if (await disableBiometricNoAuthen(username: event.username)) {
      emit(_unAuthenticatedBio);
    } else {
      emit(_authenticatedBio);
    }
  }

  void _onBiometricLogin(
    LocalAuthBiometricLoginEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    if (await bioMetricLogin(username: event.username)) {
      emit(_authenticatedBio);
    } else {
      emit(_unAuthenticatedBio);
    }
  }

  void _onCheckBioStatus(
    LocalAuthCheckBioStatusEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    if (await _checkBioStatus(username: event.username)) {
      emit(_authenticatedBio);
    } else {
      emit(_unAuthenticatedBio);
    }
  }

  void _onCleanCachedData(
    LocalAuthCleanCachedDataEvent event,
    Emitter<LocalAuthState> emit,
  ) async {
    emit(_procesing);
    _cleanUserPrivate();
    emit(_authenticatedBio);
  }

//* --------------------------------------------------------------------------------------
  // MARK: STATES
  LocalAuthUnAuthenticated get _unAuthenticatedBio =>
      LocalAuthUnAuthenticated(biometricTypes: biometricTypes);
  LocalAuthProcessing get _procesing => LocalAuthProcessing(
        biometricTypes: biometricTypes,
        account: account,
        cachedUsername: cachedBioUsername,
        cachesPassword: cachedBioPassword,
      );
  LocalAuthAuthenticated get _authenticatedBio => LocalAuthAuthenticated(
        biometricTypes: biometricTypes,
        account: account,
        cachedUsername: cachedBioUsername,
        cachesPassword: cachedBioPassword,
      );

  Future<void> getBiometricTypes() async {
    biometricTypes = await UserPrivateRepo().getBiometricTypes();
    print(biometricTypes);
  }

  Future<bool> checkIsActiveBiometricAccount({required String username}) async {
    final BiometricAccount account =
        await UserPrivateRepo().getBiometricAccount(username);
    return (account.bioUsername == username &&
        account.bioPassword != null &&
        (account.bioPassword ?? '').isNotEmpty);
  }

  Future<bool> bioMetricLogin({required String username}) async {
    if (await checkIsActiveBiometricAccount(username: username)) {
      if (await UserPrivateRepo().authenticateUser()) {
        final BiometricAccount biometricAccount =
            await UserPrivateRepo().getBiometricAccount(username);
        AppBlocs.authenticationBloc.add(AuthenticationLoginEvent(
            username: username,
            password: biometricAccount.bioPassword ?? '',
            remember: true));
        return true;
      }
      return false;
    } else {
      showDialogBio(
          title: "Đăng nhập" +
              (biometricTypes.contains(BiometricType.face)
                  ? " FaceID"
                  : " TouchID") +
              " thất bại",
          body: "Tính năng đăng nhập bằng" +
              (biometricTypes.contains(BiometricType.face)
                  ? " FaceID"
                  : " TouchID") +
              " chưa được cài đặt. Vui lòng đăng nhập bằng mật khẩu và kiểm tra lại.");
      return false;
    }
  }

  Future<bool> activeBiometric(
      {required String username, required String password}) async {
    final bool _result = await UserPrivateRepo().saveBiometricAccount(
        BiometricAccount(bioUsername: username, bioPassword: password));
    if (_result) {
      BiometricAccount account =
          await UserPrivateRepo().getBiometricAccount(username);
      cachedBioUsername = account.bioUsername ?? '';
      return _result;
    } else {
      return _result;
    }
  }

  Future<bool> _checkBioStatus({required String username}) async {
    final BiometricAccount account =
        await UserPrivateRepo().getBiometricAccount(username);
    if (account.bioPassword != null &&
        (account.bioPassword ?? '').isNotEmpty &&
        account.bioUsername != null &&
        (account.bioUsername ?? '').isNotEmpty) {
      cachedBioUsername = account.bioUsername!;
      cachedBioPassword = account.bioPassword!;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> disableBiometric({required String username}) async {
    final BiometricAccount account =
        BiometricAccount(bioPassword: '', bioUsername: username);
    if (await UserPrivateRepo().authenticateUser()) {
      final bool result = await UserPrivateRepo().saveBiometricAccount(account);
      if (result) {
        cachedBioUsername = '';
        cachedBioPassword = '';
        AppBlocs.localAuthBloc.add(LocalAuthCheckBioStatusEvent(
            username: AppBlocs.authenticationBloc.cachedUsername));
        AppNavigator.pop();
        return true;
      } else {
        showDialogBio(
            title: "Không thành công",
            body: ((AppBlocs.localAuthBloc.biometricTypes.isNotEmpty &&
                        AppBlocs.localAuthBloc.biometricTypes
                            .contains(BiometricType.face))
                    ? "Face ID"
                    : "Touch ID") +
                ' của quý khách không khớp');
        return false;
      }
    }
    return false;
  }

  Future<bool> disableBiometricNoAuthen({required String username}) async {
    final BiometricAccount account =
        BiometricAccount(bioPassword: '', bioUsername: '');
    final bool result = await UserPrivateRepo().saveBiometricAccount(account);
    if (result) {
      cachedBioUsername = '';
      cachedBioPassword = '';
      AppBlocs.localAuthBloc.add(LocalAuthCheckBioStatusEvent(
          username: AppBlocs.authenticationBloc.cachedUsername));
      return true;
    } else {
      showDialogBio(
          title: "Không thành công",
          body: ((AppBlocs.localAuthBloc.biometricTypes.isNotEmpty &&
                      AppBlocs.localAuthBloc.biometricTypes
                          .contains(BiometricType.face))
                  ? "Face ID"
                  : "Touch ID") +
              ' của quý khách không khớp');
      return false;
    }
  }

  void _cleanUserPrivate() {
    account = BiometricAccount.empty;
    cachedBioUsername = '';
    cachedBioPassword = '';
  }
}
