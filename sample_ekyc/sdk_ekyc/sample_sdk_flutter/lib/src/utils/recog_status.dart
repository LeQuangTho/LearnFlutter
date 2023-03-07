import 'package:flutter/material.dart';

enum RecogStatus { noCard, invalidCard, glareCard, wrongCard, strangeObject }

extension RecogStatusExt on RecogStatus {
  Color get color {
    switch (this) {
      case RecogStatus.noCard:
        return Colors.white;
      // return Colors.red;
      case RecogStatus.invalidCard:
        return Colors.red;
      case RecogStatus.glareCard:
        return Colors.red;
      case RecogStatus.wrongCard:
        return Colors.red;
      case RecogStatus.strangeObject:
        return Colors.red;
    }
  }

  Image get warningIcon {
    switch (this) {
      case RecogStatus.noCard:
        return Image.asset('Group_20.png', width: 60);
      case RecogStatus.invalidCard:
        return Image.asset('Group_20.png', width: 60);
      case RecogStatus.glareCard:
        return Image.asset('Group_20.png', width: 60);
      case RecogStatus.wrongCard:
        return Image.asset('Group_20.png', width: 60);
      case RecogStatus.strangeObject:
        return Image.asset('Group_20.png', width: 60);
    }
  }

  String get message {
    switch (this) {
      case RecogStatus.noCard:
        return "Position your Card inside the frame";
      case RecogStatus.invalidCard:
        return "Scan your real Card";
      case RecogStatus.glareCard:
        return "Move Card away from directed light";
      case RecogStatus.wrongCard:
        return "Scan the right side of your Card";
      case RecogStatus.strangeObject:
        return "Remove fingers/ objects on card";
    }
  }

  String get title {
    switch (this) {
      case RecogStatus.noCard:
        return "No Card detected";
      case RecogStatus.invalidCard:
        return "Invalid card detected";
      case RecogStatus.glareCard:
        return "Glare detected";
      case RecogStatus.wrongCard:
        return "Wrong side detected";
      case RecogStatus.strangeObject:
        return "Strange object Detected";
    }
  }
}
