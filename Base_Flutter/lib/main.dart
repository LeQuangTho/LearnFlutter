import 'package:base_flutter/services/service_locator.dart';
import 'package:base_flutter/ui/router.dart' as router;
import 'package:base_flutter/ui/views/home/home_view.dart';
import 'package:base_flutter/ui/views/unknown_route_view.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: router.initialRoute,
      onGenerateRoute: router.Router.generateRoute,
      routes: router.Router.defineRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const UnknownRouteView(),
      ),
      home: const HomeView(),
    );
  }
}
