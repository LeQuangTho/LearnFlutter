import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/authentication/authentication_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/ekyc/ekyc_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/notification/notification_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/timer/resend_otp/resend_otp_bloc.dart';

import 'app_data/app_data_bloc.dart';
import 'app_state_management/app_state_management_bloc.dart';
import 'pin_code_bloc/pin_code_bloc.dart';
import 'timer/timer_bloc.dart';
import 'local_auth/local_auth_bloc.dart';
import 'user_remote/user_remote_bloc.dart';

class AppBlocs {
  static final appDataBloc = AppDataBloc();
  static final appStateManagementBloc = AppStateManagementBloc();
  static final timerBloc = TimerBloc();
  static final resendBloc = ResendOtpBloc();
  static final userRemoteBloc = UserRemoteBloc();
  static final notificationBloc = NotificationBloc();
  static final localAuthBloc = LocalAuthBloc();
  static final ekycBloc = EkycBloc();
  static final authenticationBloc = AuthenticationBloc();
  static final pinCodeBloc = PinCodeBloc();
  static final List<BlocProvider> blocProviders = [
    BlocProvider<AppStateManagementBloc>(
      create: (context) => appStateManagementBloc,
    ),
    BlocProvider<TimerBloc>(
      create: (context) => timerBloc,
    ),
    BlocProvider<AppDataBloc>(
      create: (context) => appDataBloc,
    ),
    BlocProvider<UserRemoteBloc>(
      create: (context) => userRemoteBloc,
    ),
    BlocProvider<NotificationBloc>(
      create: (context) => notificationBloc,
    ),
    BlocProvider<LocalAuthBloc>(
      create: (context) => localAuthBloc,
    ),
    BlocProvider<EkycBloc>(
      create: (context) => ekycBloc,
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => authenticationBloc,
    ),
    BlocProvider<ResendOtpBloc>(
      create: (context) => resendBloc,
    ),
    BlocProvider<PinCodeBloc>(
      create: (context) => pinCodeBloc,
    ),
  ];

  static void dispose() {
    appStateManagementBloc.close();
  }

  static void logOut() {
    ekycBloc.add(EkycCleanDataEvent());
    userRemoteBloc.add(UserRemoteCleanDataEvent());
  }

  static void runApp() {
    cleanBloc();
  }

  static void initialHomeBlocWithoutAuth() {}

  static void initialHomeBlocWithAuth() {}

  static void cleanBloc() {}

  /// Singleton Factory
  static final AppBlocs _instance = AppBlocs._internal();

  factory AppBlocs() {
    return _instance;
  }

  AppBlocs._internal();
}
