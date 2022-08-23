import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_game/racing_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
  final theme = ThemeData(
    textTheme: TextTheme(
      headline1: GoogleFonts.vt323(
        fontSize: 35,
        color: Colors.white,
      ),
      button: GoogleFonts.vt323(
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
      bodyText1: GoogleFonts.vt323(
        fontSize: 28,
        color: Colors.grey,
      ),
      bodyText2: GoogleFonts.vt323(
        fontSize: 18,
        color: Colors.grey,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        minimumSize: const Size(150, 50),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hoverColor: Colors.red.shade700,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.shade700,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameWidget<RacingGame>(
        game: RacingGame(),
        overlayBuilderMap: const {},
      ),
      theme: theme,
    );
  }
}
