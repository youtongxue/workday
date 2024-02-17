import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../utils/date_util.dart';
import '../calendar/dto/dayinfo_db.dart';
import '../calendar/viewdoel/calendar_page_vm.dart';

class StatisticsPageViewModel extends GetxController {
  final calendarPageViewModel = Get.find<CalendarPageViewModel>();
  var yearStatisticsDay = 0.0.obs;
  var needShowMonthCount = 0.obs;

  // 存储一年所有数据
  List<List<DayInfoDateBase>> yearData = [];
  // 某月总共天数
  List<int> dayInMonthList = [];
  // 某月出勤天数
  List<double> statisticsDayInMonth = [];

  /// 查询某年某月出勤了多少天
  Future<List<List<DayInfoDateBase>>> queryMonthStatisticsData() async {
    final firstDaysOfMonthsInYearList = DateUtil.getFirstDaysOfMonthsInYear(
        calendarPageViewModel.currentYear.value);

    for (var daysOfMonthsInYear in firstDaysOfMonthsInYearList) {
      yearData.add(
          await DayInfoProvider.instance.getYearMonthInfo(daysOfMonthsInYear));
    }

    return yearData;
  }

  /// 计算某年某月出勤了多少天
  Future<void> sumStatisticsDay() async {
    final dataInYear = await queryMonthStatisticsData();

    for (var dataInMonth in dataInYear) {
      double sumDayInMonth = 0;
      for (var day in dataInMonth) {
        double sumDay = 0;
        switch (day.attendance) {
          case 0:
            sumDay = 0;
            break;
          case 1:
            sumDay = 1;
            break;
          case 2:
          case 3:
            sumDay = 0.5;
            break;
        }
        sumDayInMonth = sumDayInMonth + sumDay;
      }
      dayInMonthList.add(dataInMonth.length);
      statisticsDayInMonth.add(sumDayInMonth);
    }

    double sumYearStatisticsDay = 0;
    for (var monthData in statisticsDayInMonth) {
      sumYearStatisticsDay = sumYearStatisticsDay + monthData;
    }
    yearStatisticsDay.value = sumYearStatisticsDay;
  }

  /// 计算需要绘制几个月的数据
  void _showMonthCount() {
    if (calendarPageViewModel.currentYear < DateUtil.todayDateTime().year) {
      needShowMonthCount.value = 12;
    } else if (calendarPageViewModel.currentYear.value ==
        DateUtil.todayDateTime().year) {
      needShowMonthCount.value = DateUtil.todayDateTime().month;
    } else {
      needShowMonthCount.value = 0;
    }
  }

  @override
  void onReady() async {
    super.onReady();

    await sumStatisticsDay();
    _showMonthCount();
    debugPrint(
        '${calendarPageViewModel.currentYear.value} 年出勤数据: $statisticsDayInMonth');
    debugPrint(
        '${calendarPageViewModel.currentYear.value} 月天数数据: $dayInMonthList');
  }

  void refreshData() async {
    yearStatisticsDay.value = 0.0;
    needShowMonthCount.value = 0;
    yearData.clear();
    dayInMonthList.clear();
    statisticsDayInMonth.clear();

    await sumStatisticsDay();
    _showMonthCount();
    update();
  }
}
