import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../utils/date_util.dart';

class CalendarPageViewModel extends GetxController {
  var currentYear = 2024.obs;
  var currentMonth = 1.obs;
  var calendarInfoHeight = 200.obs;
  var currentRowsMonth = 6.obs; // 选中月需要绘制多少行

  var offset = 0.0.obs;

  void setRandomHeight() {
    calendarInfoHeight.value = Random().nextInt(2);
  }

  void changeCurrentMonth(int newCurrentMonth) {
    currentMonth.value = newCurrentMonth + 1;
    calculateRowForMonth();
  }

  void calculateRowForMonth() {
    final row =
        DateUtil.calculateRowsForMonth(currentYear.value, currentMonth.value);
    currentRowsMonth.value = row;

    if (row == 5) {
      offset.value = -(((Get.mediaQuery.size.height / 2) - 116) / 6);
    } else if (row == 6) {
      offset.value = 0;
    }

    debugPrint("绘制行: ${currentRowsMonth.value}");
  }

  String dayText(int monthFirstDayIsWeek, int monthDay, int column, int row) {
    var dayText = "";
    final itemIndex = (column * 7 + row + 1);
    final result = itemIndex - monthFirstDayIsWeek;

    debugPrint(
        "monthFirstDayIsWeek: > > > $monthFirstDayIsWeek > > > itemIndex: > > > $itemIndex > > > result: > > > $result");

    if (result > 0) {
      final dayResult = result.toString();
      if (int.parse(dayResult) <= monthDay) {
        dayText = dayResult;
      } else {
        dayText = "";
      }
    }
    return dayText;
  }
}
