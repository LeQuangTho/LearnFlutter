import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  static List<String?> routeNames = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    routeNames.add(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (routeNames.length > 1) {
      routeNames.removeLast();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace();
    routeNames[routeNames.length - 1] = newRoute?.settings.name ?? '';
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final int indexOfRoute = routeNames.indexOf(route.settings.name ?? '');
    if (indexOfRoute != -1) {
      routeNames.removeRange(indexOfRoute, routeNames.length);
    }
  }

  // Static
  static String? get currentRouteName =>
      routeNames.lastWhere((route) => route != null && route.isNotEmpty,
          orElse: () => null);
}
