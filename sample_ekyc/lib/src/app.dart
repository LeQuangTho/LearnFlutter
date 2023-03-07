import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdsaison_signing/src/BLOC/app_data/app_data_bloc.dart';
import 'BLOC/app_blocs.dart';
import 'BLOC/app_state_management/app_state_management_bloc.dart';
import 'UI/designs/sizer_custom/sizer.dart';
import 'UI/screens/pre_login/pre_login_screen.dart';
import 'UI/screens/screens.dart';
import 'navigations/app_navigator_observer.dart';
import 'navigations/app_pages.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppBlocs.appDataBloc.add(AppDataSetupEvent(context: context));
  }

  @override
  void dispose() {
    AppBlocs.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppBlocs.appStateManagementBloc.add(AppStateManagementResumeEvent());
        break;
      case AppLifecycleState.paused:
        AppBlocs.appStateManagementBloc
            .add(AppStateManagementTurnOnBackGroundEvent());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ScreenUtilInit(
          designSize: Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: child!,
                );
              },
              title: "$UNIT_NAME Signing",
              theme: ThemeData(
                backgroundColor: Colors.transparent,
                scaffoldBackgroundColor: Colors.transparent,
                primaryColor: Colors.transparent,
                brightness: Brightness.light,
                appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
                iconTheme: IconThemeData(),
              ),
              navigatorKey: AppNavigator.navigatorKey,
              supportedLocales: [
                Locale('vi', 'VN'),
                Locale('en', 'US'),
              ],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              onGenerateRoute: AppNavigator.getRoute,
              navigatorObservers: [
                AppNavigatorObserver(),
              ],
              debugShowCheckedModeBanner: false,
              home: BlocBuilder<AppDataBloc, AppDataState>(
                  builder: (context, state) {
                if (state is AppDataSetupSuccess) {
                  if (AppBlocs.authenticationBloc.openedApp &&
                      AppBlocs.authenticationBloc.cachedUsername.isEmpty) {
                    return PreLoginScreen();
                  } else if (AppBlocs
                      .authenticationBloc.cachedUsername.isNotEmpty) {
                    return LoginScreen();
                  } else {
                    return OnboardingScreen();
                  }
                } else {
                  return InitScreen();
                }
              }),
            );
          },
        );
      },
    );
  }
}
