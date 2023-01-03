import 'package:flutter/material.dart';

class AppBoxShadows {
  static final List<BoxShadow> low = [
    BoxShadow(
      color: const Color(0XFF6A7381).withOpacity(0.02),
      offset: const Offset(0, 2),
      blurRadius: 8,
    )
  ];
  static List<BoxShadow> med = [
    BoxShadow(
      color: const Color(0XFF6A7381).withOpacity(0.08),
      offset: const Offset(0, 2),
      blurRadius: 8,
    )
  ];
  static List<BoxShadow> high = [
    BoxShadow(
      color: const Color(0XFF6A7381).withOpacity(0.1),
      offset: const Offset(0, 4),
      blurRadius: 16,
    ),
  ];
  static const List<BoxShadow> top = [
    BoxShadow(
      color: Color(0XFF6A7381),
      offset: Offset(0, -2),
      blurRadius: 8,
    ),
  ];
  static const List<BoxShadow> left = [
    BoxShadow(
      color: Color(0XFF6A7381),
      offset: Offset(-1, 2),
      blurRadius: 8,
    ),
  ];
  static const List<BoxShadow> right = [
    BoxShadow(
      color: Color(0XFF6A7381),
      offset: Offset(1, 0),
      blurRadius: 8,
    ),
  ];
}
