import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:workday/pages/calendar/enumm/attendance_enum.dart';

import '../../../utils/date_util.dart';
import '../dto/dayinfo.dart';

class CalendarPageViewModel extends GetxController {
  final todayDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var currentDayDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var currentYear = 2024.obs;
  var currentMonth = 1.obs;
  var calendarInfoHeight = 200.obs;
  var currentRowsMonth = 6.obs; // 选中月需要绘制多少行
  var offset = 0.0.obs; // 底部信息偏移量

  var dayCheckBox = false.obs;
  var morningCheckBox = false.obs;
  var afternoonCheckBox = false.obs;

  final calendarPagerController = PageController();
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  // 月份所有日，DateTime信息
  late List<DayInfoDTO> dayInfoDTOList = [];
  // 月份第一个月为星期几
  late int firstDayOfWeek;
  // 某月有多少天
  late int monthMaxDay;

  void setRandomHeight() {
    calendarInfoHeight.value = Random().nextInt(2);
  }

  void changeCurrentMonth(int newCurrentMonth) {
    debugPrint("newCurrentMonth > > > : $newCurrentMonth");
    currentMonth.value = newCurrentMonth + 1;
    _calculateRowForMonth();
    _autoDraggableScroll();
  }

  void _calculateRowForMonth() {
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

  /// 初始化月份信息
  void initCurrentMonthInfo(int year, int month) {
    dayInfoDTOList.clear();
    final dayInMonth = DateUtil.dayInfoInMonth(year, month);
    final lunarInMonth = DateUtil.dayLunarInMonth(dayInMonth);

    for (var i = 0; i < dayInMonth.length; i++) {
      DayInfoDTO dayInfoDTO =
          DayInfoDTO(dateTime: dayInMonth[i], lunar: lunarInMonth[i]);
      dayInfoDTOList.add(dayInfoDTO);
    }

    firstDayOfWeek = DateUtil.firstDayOfWeek(year, month);
    monthMaxDay = DateUtil.getDaysInMonth(year, month);
  }

  /// 根据day数值获取DateTime
  DayInfoDTO? oneDayDayInfoDTO(int column, int row, int month) {
    String? dayText;
    final itemIndex = (column * 7 + row);
    final result = itemIndex - firstDayOfWeek;

    if (result >= 0) {
      if (result <= monthMaxDay) {
        dayText = result.toString();
      }
    }

    if (null == dayText) return null;
    if (int.parse(dayText) >= dayInfoDTOList.length) return null;

    final date = dayInfoDTOList[int.parse(dayText)];

    debugPrint(
        "第一天: $firstDayOfWeek index: $itemIndex 显示日期: $result date: ${date.dateTime.day}");

    return date;
  }

  @override
  void onReady() {
    super.onReady();
    // 初始化跳转到对应月份pager
    calendarPagerController.jumpToPage(currentDayDateTime.value.month - 1);
  }

  /// 点击今天Button回到今天
  void scrollerToToDay() {
    // calendarPagerController.animateToPage(currentDayDateTime.month - 1,
    //     duration: const Duration(milliseconds: 200), curve: Curves.linear);
    calendarPagerController.jumpToPage(todayDateTime.month - 1);
    currentDayDateTime.value = todayDateTime;
  }

  /// 根据月需要绘制的行，适配底部信息高度
  void _autoDraggableScroll() {
    final screenHeight = Get.height;
    const titleBar = 116;
    final line = 0.4 * (currentRowsMonth.value - 1);

    draggableScrollableController.animateTo(
        (screenHeight -
                titleBar -
                line -
                (((screenHeight / 2) - titleBar) / 6) *
                    currentRowsMonth.value) /
            screenHeight,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear);
  }
}
