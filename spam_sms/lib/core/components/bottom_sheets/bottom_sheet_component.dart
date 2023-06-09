import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/components/divider_components/horizontal_divider.dart';

class BottomSheetComponent extends StatefulWidget {
  const BottomSheetComponent({
    super.key,
    this.header,
    required this.body,
    this.textFinish,
    this.onFinish,
  });

  final Widget? header;
  final Widget body;
  final String? textFinish;
  final void Function()? onFinish;

  @override
  State<BottomSheetComponent> createState() => _BottomSheetComponentState();
}

class _BottomSheetComponentState extends State<BottomSheetComponent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Column(
        children: [
          widget.header ?? const SizedBox(),
          const HorizontalDivider(),
          Expanded(child: widget.body),
          if (widget.onFinish != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton.icon(
                onPressed: () {
                  Get.back<dynamic>();
                  widget.onFinish?.call();
                },
                icon: const Icon(Icons.done),
                label: Text(widget.textFinish ?? ''),
              ),
            ),
        ],
      ),
    );
  }
}
