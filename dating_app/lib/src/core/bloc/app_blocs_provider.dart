import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class AppBlocs {
  factory AppBlocs() {
    return _instance;
  }

  AppBlocs._internal();

  static void logOut() {}

  static void runApp() {
    cleanBloc();
  }

  static void initialHomeBlocWithoutAuth() {}

  static void initialHomeBlocWithAuth() {}

  static void cleanBloc() {}

  /// Singleton Factory
  static final AppBlocs _instance = AppBlocs._internal();

  // BLOC Providers
  static final List<BlocProvider> blocProviders = [];
}

/// Use transformer
EventTransformer<T> debounce<T>({Duration? duration}) {
  return (events, mapper) => events
      .debounceTime(duration ?? const Duration(milliseconds: 1000))
      .flatMap(mapper);
}
