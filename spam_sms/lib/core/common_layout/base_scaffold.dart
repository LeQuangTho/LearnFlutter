import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.contentPadding,
    this.floatingActionButton,
  });

  final AppBar? appBar;
  final Widget body;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? floatingActionButton;

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: Scaffold(
        appBar: widget.appBar,
        floatingActionButton: widget.floatingActionButton,
        body: Container(
          padding: widget.contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
          child: widget.body,
        ),
      ),
    );
  }
}
