import 'package:sample_sdk_flutter/src/components/primary_appbar.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        appBar: AppBar(),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.asset("assets/images/waiting.png",
              package: 'sample_sdk_flutter'),
        ),
      ),
    );
  }
}
