import 'package:flutter/material.dart';

class SaveWithNTFListener extends StatefulWidget {
  const SaveWithNTFListener({Key? key}) : super(key: key);

  @override
  State<SaveWithNTFListener> createState() => _SaveWithNTFListenerState();
}

class _SaveWithNTFListenerState extends State<SaveWithNTFListener> {
  List<String> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {});
        },
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(data[index]),
          onTap: () async {},
        ),
      ),
    );
  }
}
