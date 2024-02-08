import 'package:flutter/material.dart';

class NoScrollController extends ScrollController {
  @override
  void jumpTo(double value) {
    // 禁止跳转
  }

  @override
  Future<void> animateTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async {}
}
