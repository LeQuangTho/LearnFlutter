import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_ble/next_ble.dart';

class ExtensionsBLE extends StatefulWidget {
  const ExtensionsBLE({Key? key}) : super(key: key);

  @override
  State<ExtensionsBLE> createState() => _ExtensionsBLEState();
}

class _ExtensionsBLEState extends State<ExtensionsBLE> {
  late NextBle nextBle;

  @override
  void initState() {
    nextBle = NextBle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await nextBle.openSetting();
                },
                child: const Text("Open Setting"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await nextBle.requestDiscoverable(
                    duration: 180,
                  );
                },
                child: const Text("Request Discovery"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = await nextBle.getName();
                  Fluttertoast.showToast(msg: "$name");
                },
                child: const Text("Get Name"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = await nextBle.getName();
                  final ctl = TextEditingController(text: name);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Set name"),
                      content: TextField(
                        controller: ctl,
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            final nav = Navigator.of(context);
                            final res = await nextBle.setName(name: ctl.text);
                            if (res != null && res) {
                              Fluttertoast.showToast(
                                msg: "Change name to ${ctl.text}",
                              );
                            }

                            nav.pop();
                          },
                          child: const Text("Ok"),
                        )
                      ],
                    ),
                  );
                },
                child: const Text("Set Name"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await nextBle.startGatt();
                },
                child: const Text("Start Gatt"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nextBle.stopGatt();
    super.dispose();
  }
}
