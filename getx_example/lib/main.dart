import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/count_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      checkerboardOffscreenLayers: true,
      defaultTransition: Transition.cupertino,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final CountController c = Get.put(CountController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(
              () => Text(
                '${c.count}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {
          // c.increment();
          Get.to(const Other());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Other extends StatelessWidget {
  const Other({super.key});

  @override
  Widget build(context) {
    final CountController c = Get.find();
    return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
