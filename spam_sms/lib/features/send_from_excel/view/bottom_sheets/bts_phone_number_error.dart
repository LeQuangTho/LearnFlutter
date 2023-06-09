import 'package:flutter/material.dart';
import 'package:spam_sms/core/components/bottom_sheets/bottom_sheet_component.dart';
import 'package:spam_sms/core/components/bottom_sheets/header_bottom_sheet.dart';
import 'package:spam_sms/core/components/divider_components/vertical_divider.dart';

class BTSPhoneNumberError extends StatelessWidget {
  final List<String> data;

  const BTSPhoneNumberError({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BottomSheetComponent(
      header: const HeaderBottomSheet(title: 'Danh sách sđt không hợp lệ'),
      body: ListView.separated(
        separatorBuilder: (_, __) => const VerticalDividerCustom(height: 0.5),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(data[index]));
        },
      ),
      onFinish: () {},
      textFinish: 'Ok',
    );
  }
}
