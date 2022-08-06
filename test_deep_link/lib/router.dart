import 'package:flutter/material.dart';
import 'package:test_deep_link/main.dart';
import 'package:test_deep_link/slope_dapp.dart';

class Router {
  static Map<String, Widget Function(BuildContext)> defineRoute = {
    '/': (ctx) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(ctx, "/onConnect");
              },
              child: const Text("next"),
            ),
          ),
        ),
    '/onConnect': (ctx) => const SlopeDAppView(),
    '/on-connect': (ctx) => const MyHomePage(title: ""),
  };
}
