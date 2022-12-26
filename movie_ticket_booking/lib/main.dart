import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket_booking/controllers/home_controller.dart';
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() {
            return Positioned(
              top: controller.offset.value.dy,
              left: controller.offset.value.dx,
              child: GestureDetector(
                onScaleUpdate: (details) {
                  controller.changeScale(details.scale);
                },
                child: Draggable(
                  feedback: Transform.scale(
                    scale: controller.scale.value,
                    child: MapSelectSeats(),
                  ),
                  child: const MapSelectSeats(),
                  onDragUpdate: (details) {
                    controller.changeOffset(details.delta);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
