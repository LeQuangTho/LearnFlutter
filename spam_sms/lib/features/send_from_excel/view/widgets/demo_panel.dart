import 'package:flutter/material.dart';
import 'package:spam_sms/core/theme/app_text_style.dart';
import 'package:spam_sms/core/theme/gen/assets.gen.dart';

class DemoPanel extends StatelessWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Assets.images.imgDemoFile.image(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Vui lòng chọn file có nội dung theo mẫu theo mẫu',
              style: AppStyle.smallRegular.neutral600,
            ),
          ],
        ),
      ),
    );
  }
}
