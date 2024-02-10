import 'package:flutter/widgets.dart';

// 底部导航栏 Item
class BottomNavItem {
  String text;
  String assertIcon;
  VoidCallback onPressed;
  bool isSelected;

  BottomNavItem(this.text, this.assertIcon, this.onPressed,
      {this.isSelected = false});
}
