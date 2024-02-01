import 'dart:math';

import 'package:get/get.dart';

class CalendarPageViewModel extends GetxController {
  var currentYear = 2024.obs;
  var currentMonth = 1.obs;
  var calendarInfoHeight = 200.obs;

  void setRandomHeight() {
    calendarInfoHeight.value = Random().nextInt(2);
  }

  void changeCurrentMonth(int newCurrentMonth) {
    currentMonth.value = newCurrentMonth + 1;
  }
}
