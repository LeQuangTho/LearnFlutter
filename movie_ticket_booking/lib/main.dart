import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket_booking/widgets/map_select_seats.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          minScale: 1,
          maxScale: 10,
          child: SizedBox(
            width: 100.w,
            height: 100.h - appBar.preferredSize.height,
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/screen.png',
                    width: 80.w,
                  ),
                  const MapSelectSeats(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
