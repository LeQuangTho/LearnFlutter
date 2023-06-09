import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spam_sms/core/theme/app_text_style.dart';

class HeaderBottomSheet extends StatelessWidget {
  const HeaderBottomSheet({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyle.paragraphSemiBold.neutral800,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: Get.back<dynamic>,
          ),
        ],
      ),
    );
  }
}
