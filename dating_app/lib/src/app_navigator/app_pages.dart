import 'package:dating_now/main.dart';
import 'package:dating_now/src/app_navigator/app_navigator_observer.dart';
import 'package:dating_now/src/app_navigator/app_routes.dart';
import 'package:dating_now/src/app_navigator/transition_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic>? getRoute(RouteSettings settings) {
    final Map<String, dynamic> arguments = _getArguments(settings);

    switch (settings.name) {
      // Define Navigator Page
      case Routes.ROOT:
        return _buildRoute(
          settings,
          App(),
        );
      default:
        return null;
    }
  }

  static AppMaterialPageRoute<dynamic> _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    return AppMaterialPageRoute(
      builder: (context) => builder,
      settings: routeSettings,
    );
  }

  static Map<String, dynamic> _getArguments(RouteSettings settings) {
    if (settings.arguments is Map<String, dynamic>) {
      return settings.arguments as Map<String, dynamic>;
    }
    return {};
  }

  static Future<dynamic> push<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamed(route, arguments: arguments);
  }

  static Future<dynamic> pushNamedAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    return state.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future<dynamic> replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return state.pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String route) {
    state.popUntil(ModalRoute.withName(route));
  }

  static void pop() {
    if (canPop) {
      state.pop();
    }
  }

  static bool get canPop => state.canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;
}
