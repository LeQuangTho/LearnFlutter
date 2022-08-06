import 'package:base_flutter/services/service_locator.dart';
import 'package:base_flutter/ui/base/_base_view.dart';
import 'package:base_flutter/ui/views/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeModel model = locator<HomeModel>();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) {
        // this.model = model;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Consumer<HomeModel>(
                builder: (context, value, child) => Text(
                  '${value.counter}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<HomeModel>(
          builder: (context, value, child) {
            return FloatingActionButton(
              onPressed: value.incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
