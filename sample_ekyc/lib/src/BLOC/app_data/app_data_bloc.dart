import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../configs/application.dart';
import '../../configs/languages/localization.dart';
import '../../constants/hard_constants.dart';
import '../../helpers/device_infor_helper.dart';
import '../app_blocs.dart';
import '../app_state_management/app_state_management_bloc.dart';
import '../authentication/authentication_bloc.dart';
import '../local_auth/local_auth_bloc.dart';

part 'app_data_event.dart';
part 'app_data_state.dart';

/// Quản lý các giá trị được khởi tạo khi chạy App và trong thời gian chạy App

class AppDataBloc extends Bloc<AppDataEvent, AppDataState> {
  AppDataBloc() : super(AppDataInitial()) {
    on<AppDataSetupEvent>(_onAppDataSetup);
  }

  void _onAppDataSetup(AppDataEvent event, Emitter<AppDataState> emit) async {
    try {
      if (event is AppDataSetupEvent) {
        emit(AppDataSetupInprogress());
        await AppData().initialApplicationData(event.context);
        AppData().initSdkConfig();
        await LanguageService().initialLanguage(event.context);
        AppBlocs.localAuthBloc.add(LocalAuthGetBiometricTypesSupportEvent());
        AppBlocs.authenticationBloc
            .add(AuthenticationCheckRememberedAccountEvent());
        await DeviceInforHelper().getDeviceInfor();
        AppBlocs.authenticationBloc.add(GetFirstLoginEvent());
        AppBlocs.authenticationBloc.add(GetFirstOpenAppEvent());
        await Future.delayed(DELAY_500_MS * 3);
        AppBlocs.appStateManagementBloc.add(AppStateManagementRunAppEvent());
        emit(AppDataSetupSuccess());
      }
    } catch (e) {
      emit(AppDataSetupFail());
    }
  }
}
