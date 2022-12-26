import 'dart:ui';

import 'package:get/get.dart';

class HomeController extends GetxController {
  var offset = const Offset(0, 0).obs;
  var scale = 1.0.obs;

  void changeOffset(Offset o) {
    offset.value = Offset(offset.value.dx + o.dx, offset.value.dy + o.dy);
  }

  void changeScale(double o) {
    scale.value = o;
  }
}
