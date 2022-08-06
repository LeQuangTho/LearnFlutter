import 'package:base_flutter/ui/views/home/home_view.dart';
import 'package:base_flutter/ui/views/second/second_view.dart';
import 'package:flutter/material.dart';

const String initialRoute = "/";

class Router {
  static Map<String, Widget Function(BuildContext)> defineRoute = {
    // "/": (context) => const SplashView(),
    HomeView.routeName: (context) => const HomeView(),
  };

  static Route? generateRoute(RouteSettings settings) {
    if (settings.name == SecondView.routeName) {
      final args = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) {
          return SecondView(
            title: args,
          );
        },
      );
    }

    assert(false, 'Need to implement ${settings.name}');
    return null;
  }
}
