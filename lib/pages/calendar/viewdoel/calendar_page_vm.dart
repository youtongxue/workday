import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:workday/pages/calendar/enumm/attendance_enum.dart';

import '../../../components/view/we_chat_loading.dart';
import '../../../utils/date_util.dart';
import '../dto/dayinfo.dart';
import '../dto/dayinfo_db.dart';

class CalendarPageViewModel extends GetxController {
  var todayDateTime = DateUtil.todayDateTime();
  var currentDayDateTime = DateUtil.todayDateTime().obs;
  var currentYear = DateUtil.todayDateTime().year.obs;
  var currentMonth = 1.obs;
  var currentRowsMonth = 6.obs; // 选中月需要绘制多少行
  var offset = 0.0.obs; // 底部信息偏移量

  var dayCheckBox = false.obs;
  var morningCheckBox = false.obs;
  var afternoonCheckBox = false.obs;

  //late DayInfoDateBase? currentClickDayInfo; // 点击选中的日期

  final calendarPagerController =
      PageController(initialPage: DateUtil.todayDateTime().month - 1);
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  // 月份所有日DateTime信息
  late List<Rx<DayInfoDTO>> dayInfoDTOList = [];

  // 月份第一个月为星期几
  late int firstDayOfWeek;

  // 某月有多少天
  late int monthMaxDay;

  /// 改变选中月份
  Future<void> changeCurrentMonth(int newCurrentMonth) async {
    // 此处根据界面上是否存在Dialog，决定是否再显示Dialog
    if (!SmartDialog.config.checkExist() &&
        (DateTime(currentYear.value, newCurrentMonth + 1, 1)
                .compareTo(DateUtil.todayDateTime()) <=
            0)) {
      SmartDialog.show(
        backDismiss: false,
        clickMaskDismiss: false,
        maskColor: Colors.transparent,
        useAnimation: false,
        displayTime: const Duration(milliseconds: 600),
        builder: (BuildContext context) {
          return const CircleLoadingIndicator();
        },
      );
    }
    currentMonth.value = newCurrentMonth + 1;
    debugPrint("当前选中月份 > > > : $currentMonth");
    _calculateRowForMonth();
    _autoDraggableScroll();
    await _initCurrentMonthDayInfo();
  }

  /// 初始化需要绘制多少行
  void _calculateRowForMonth() {
    final row =
        DateUtil.calculateRowsForMonth(currentYear.value, currentMonth.value);
    currentRowsMonth.value = row;

    if (row == 5) {
      offset.value = -(((Get.mediaQuery.size.height / 2) - 116) / 6);
    } else if (row == 6) {
      offset.value = 0;
    }

    //debugPrint("绘制行: ${currentRowsMonth.value}");
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

  /// 将选中月信息从数据库中读出来
  Future<void> _initCurrentMonthDayInfo() async {
    for (int i = 0; i < dayInfoDTOList.length; i++) {
      final dayId = DateUtil.generationDayId(dayInfoDTOList[i].value.dateTime);
      final dayInfoDataBase = await DayInfoProvider.instance.getDayInfo(dayId);
      if (dayInfoDataBase != null &&
          dayInfoDTOList[i].value.attendance != dayInfoDataBase.attendance) {
        dayInfoDTOList[i].update((old) {
          debugPrint(
              '$dayId 更新UI数据: ${dayInfoDTOList[i].value.attendance} > > > ${dayInfoDataBase.attendance}');
          old!.attendance = dayInfoDataBase.attendance;
        });
      }
    }
  }

  /// 初始化月份信息
  void initCurrentMonthInfo(int year, int month) {
    debugPrint('> > > 初始化 $year $month 月信息 < < <');
    dayInfoDTOList.clear();
    firstDayOfWeek = DateUtil.firstDayOfWeek(year, month);
    monthMaxDay = DateUtil.getDaysInMonth(year, month);
    final dateTimeList = DateUtil.dayInfoInMonth(year, month);
    final lunarList = DateUtil.dayLunarInMonth(dateTimeList);

    for (int i = 0; i < dateTimeList.length; i++) {
      dayInfoDTOList
          .add(DayInfoDTO(dateTime: dateTimeList[i], lunar: lunarList[i]).obs);
    }
  }

  /// 根据day数值获取DateTime
  Rx<DayInfoDTO>? oneDayDayInfoDTO(int column, int row, int month) {
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

    // debugPrint(
    //     "第一天: $firstDayOfWeek index: $itemIndex 显示日期: $result date: ${date.dateTime.day}");

    return date;
  }

  /// 点击今天Button回到今天
  Future<void> scrollerToToDay() async {
    calendarPagerController.jumpToPage(todayDateTime.month - 1);
    await changeCurrentMonth(todayDateTime.month - 1);
    clickOneDay(todayDateTime);
  }

  /// 选择出勤
  Future<void> selectAttendance(
      AttendanceEnum attendanceEnum, bool? value) async {
    if (null != value && value == false) {
      attendanceEnum = AttendanceEnum.unselect;
    }

    switch (attendanceEnum) {
      case AttendanceEnum.unselect:
        dayCheckBox.value = false;
        morningCheckBox.value = false;
        afternoonCheckBox.value = false;
        break;
      case AttendanceEnum.allDay:
        dayCheckBox.value = value!;
        morningCheckBox.value = false;
        afternoonCheckBox.value = false;
        break;
      case AttendanceEnum.morning:
        dayCheckBox.value = false;
        morningCheckBox.value = value!;
        afternoonCheckBox.value = false;
        break;
      case AttendanceEnum.afternoon:
        dayCheckBox.value = false;
        morningCheckBox.value = false;
        afternoonCheckBox.value = value!;
        break;
    }

    await _handleAttendance(attendanceEnum);
  }

  /// 处理出勤数据
  Future<void> _handleAttendance(AttendanceEnum attendanceEnum) async {
    debugPrint('处理出勤选择事件 》 》 》 》 》');
    // 同步数据库
    final clickDayInfo = await DayInfoProvider.instance
        .getDayInfo(DateUtil.generationDayId(currentDayDateTime.value));
    if (null != clickDayInfo) {
      clickDayInfo.attendance = attendanceEnum.attendance;
      await DayInfoProvider.instance.update(clickDayInfo);
      // 更新UI
      await _initCurrentMonthDayInfo();
    }
  }

  @override
  void onReady() async {
    super.onReady();

    scrollerToToDay();
    // 初始化数据库中日期信息
    if (!(await _checkCurrentYearData())) {
      await _insertCurrentYearDate();
    }
  }

  /// 将选中年份日期信息写入本地数据库
  Future<void> _insertCurrentYearDate() async {
    final daysInYear = DateUtil.daysInYear(currentYear.value);
    final firstDayOfYear = DateUtil.firstDayOfYear(currentYear.value);
    for (int i = 0; i < daysInYear; i++) {
      final dt = firstDayOfYear.add(Duration(days: i));
      await DayInfoProvider.instance.insert(DayInfoDateBase(
        id: DateUtil.generationDayId(dt),
        attendance: AttendanceEnum.unselect.attendance,
      ));
    }
  }

  /// 读取当前选中的年份，数据库有无数据
  Future<bool> _checkCurrentYearData() async {
    final data = await DayInfoProvider.instance
        .getYearInfo(DateTime(currentYear.value, 1, 1));
    if (data.isNotEmpty) {
      debugPrint('存在${currentYear.value} > ${data.length}条数据');
      return true;
    }
    debugPrint('不存在${currentYear.value} 年数据');
    return false;
  }

  /// 选中某天
  Future<void> clickOneDay(DateTime currentDateTime) async {
    currentDayDateTime.value = currentDateTime;
    final clickDayInfo = await DayInfoProvider.instance
        .getDayInfo(DateUtil.generationDayId(currentDateTime));
    debugPrint('点击：${clickDayInfo?.id} 出勤：${clickDayInfo?.attendance}');

    if (null != clickDayInfo) {
      //currentClickDayInfo = clickDayInfo;
      switch (clickDayInfo.attendance) {
        case 0:
          dayCheckBox.value = false;
          morningCheckBox.value = false;
          afternoonCheckBox.value = false;
          break;
        case 1:
          dayCheckBox.value = true;
          morningCheckBox.value = false;
          afternoonCheckBox.value = false;
          break;
        case 2:
          dayCheckBox.value = false;
          morningCheckBox.value = true;
          afternoonCheckBox.value = false;
          break;
        case 3:
          dayCheckBox.value = false;
          morningCheckBox.value = false;
          afternoonCheckBox.value = true;
          break;
      }
    } else {
      dayCheckBox.value = false;
      morningCheckBox.value = false;
      afternoonCheckBox.value = false;
    }
  }

  Future<void> refreshData(DateTime dateTime) async {
    currentDayDateTime.value = DateTime(dateTime.year, 1, 1);
    currentYear.value = DateTime(dateTime.year, 1, 1).year;
    currentMonth.value = 1;

    calendarPagerController.jumpToPage(0);
    await changeCurrentMonth(0);
    await clickOneDay(DateTime(dateTime.year, 1, 1));

    // 初始化数据库中日期信息
    if (!(await _checkCurrentYearData())) {
      await _insertCurrentYearDate();
    }

    update();
  }
}
