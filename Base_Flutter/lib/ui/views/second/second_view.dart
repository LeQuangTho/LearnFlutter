import 'package:base_flutter/ui/widgets/image_logo.dart';
import 'package:flutter/material.dart';

class SecondView extends StatelessWidget {
  const SecondView({Key? key, required this.title}) : super(key: key);

  final String title;

  static const routeName = "/second";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: ImageLogo(),
      ),
    );
  }
}
