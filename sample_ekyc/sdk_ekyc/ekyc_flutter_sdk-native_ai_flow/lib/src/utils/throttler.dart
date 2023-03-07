import 'dart:async';
import 'package:flutter/cupertino.dart';

class Throttler {
  @visibleForTesting
  final int milliseconds;

  @visibleForTesting
  Timer? timer;

  Throttler(this.milliseconds);

  void run(VoidCallback action) {
    if (timer?.isActive ?? false) return;

    timer?.cancel();
    action();
    timer = Timer(Duration(milliseconds: milliseconds), () {});
  }

  void dispose() {
    timer?.cancel();
  }
}
