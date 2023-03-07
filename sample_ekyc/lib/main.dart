import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:hdsaison_signing/src/BLOC/app_blocs.dart';
import 'package:hdsaison_signing/src/app.dart';

import 'src/helpers/device_infor_helper.dart';
import 'src/helpers/untils/logger.dart';
import 'src/repositories/local/shared_pref.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DeviceInforHelper().initPlatformState();
  await PreferenceManager.init();
  Bloc.observer = AppBlocObserver();

  runApp(
    MultiBlocProvider(
        providers: AppBlocs.blocProviders, child: I18n(child: App())),
  );
}

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    UtilLogger.log('$UNIT_NAME BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    UtilLogger.log('$UNIT_NAME BLOC ERROR', error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    UtilLogger.log('$UNIT_NAME BLOC TRANSITION', transition.event);
    super.onTransition(bloc, transition);
  }
}
