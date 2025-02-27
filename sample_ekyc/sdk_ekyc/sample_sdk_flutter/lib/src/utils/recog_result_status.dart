import 'package:flutter/material.dart';

enum RecogResultStatus { blurryCard, missingEdge }

extension RecogResultStatusExt on RecogResultStatus {
  Color get color {
    switch (this) {
      case RecogResultStatus.blurryCard:
        return Colors.blue;
      case RecogResultStatus.missingEdge:
        return Colors.blue;
    }
  }

  Image get warningIcon {
    switch (this) {
      case RecogResultStatus.blurryCard:
        return Image.asset('assets/images/Group_21.png', width: 60);
      case RecogResultStatus.missingEdge:
        return Image.asset('assets/images/Group_21.png', width: 60);
    }
  }

  String get message {
    switch (this) {
      case RecogResultStatus.blurryCard:
        return "Make sure the details are clear";
      case RecogResultStatus.missingEdge:
        return "Make sure full document is shown";
    }
  }

  String get title {
    switch (this) {
      case RecogResultStatus.blurryCard:
        return "Blurry photo detected";
      case RecogResultStatus.missingEdge:
        return "Missing edge Card";
    }
  }
}
