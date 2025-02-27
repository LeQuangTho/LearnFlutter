import 'package:dating_now/locator.dart';
import 'package:dating_now/src/app_navigator/app_navigator.dart';
import 'package:dating_now/src/core/bloc/app_bloc_observice.dart';
import 'package:dating_now/src/core/bloc/app_blocs_provider.dart';
import 'package:dating_now/src/core/gen/fonts.gen.dart';
import 'package:dating_now/src/features/example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setup();

  // await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: AppBlocs.blocProviders,
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) => MaterialApp(
        title: 'Dating Now',
        home: HomePage(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!,
          );
        },
        theme: ThemeData(
          backgroundColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.transparent,
          primaryColor: Colors.transparent,
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
          iconTheme: IconThemeData(),
          fontFamily: FontFamily.skModernist,
        ),
        navigatorKey: AppNavigator.navigatorKey,
        supportedLocales: const [
          Locale('vi', 'VN'),
          // Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: AppNavigator.getRoute,
        navigatorObservers: [
          AppNavigatorObserver(),
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
