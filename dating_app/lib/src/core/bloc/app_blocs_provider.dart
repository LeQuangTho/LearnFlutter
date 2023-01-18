import 'package:dating_now/src/features/example/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class AppBlocs {
  factory AppBlocs() {
    return _instance;
  }

  AppBlocs._internal();

  static void runApp() {
    cleanBloc();
  }

  static void cleanBloc() {}

  /// Singleton Factory
  static final AppBlocs _instance = AppBlocs._internal();

  /// Define all Bloc
  static final HomeBloc homeBloc = HomeBloc();

  /// BLOC Providers
  static final List<BlocProvider> blocProviders = [
    BlocProvider(create: (_) => homeBloc),
  ];
}

/// Use transformer
EventTransformer<T> debounce<T>({Duration? duration}) {
  return (events, mapper) => events
      .debounceTime(duration ?? const Duration(milliseconds: 1000))
      .flatMap(mapper);
}
