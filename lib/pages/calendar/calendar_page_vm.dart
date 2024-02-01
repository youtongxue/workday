import 'dart:math';

import 'package:get/get.dart';

class CalendarPageViewModel extends GetxController {
  var calendarInfoHeight = 200.obs;

  void setRandomHeight() {
    calendarInfoHeight.value = Random().nextInt(2);
  }
}
