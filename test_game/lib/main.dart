import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_game/fire_base_database.dart';
import 'package:test_game/firebase_options.dart';
import 'package:test_game/get_it.dart';
import 'package:test_game/racing_game.dart';
import 'package:test_game/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Point position = const Point(0.0, 0.0);

  final fireBase = getIt<FireBaseDatabase>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await fireBase.checkRoom();
              },
            ),
            FloatingActionButton(
              onPressed: () async {
                fireBase.clearRoom();
              },
            ),
          ],
        ),
        body: GameWidget<RacingGame>(
          game: RacingGame(),
          overlayBuilderMap: const {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
