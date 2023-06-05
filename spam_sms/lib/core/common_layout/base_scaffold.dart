import 'package:flutter/material.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({super.key, required this.appBar, required this.body});

  final AppBar appBar;
  final Widget body;

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
    );
  }
}
