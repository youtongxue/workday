import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workday/components/container/custom_container.dart';
import 'package:workday/pages/calendar/enumm/attendance_enum.dart';
import 'package:workday/pages/calendar/viewdoel/calendar_page_vm.dart';
import 'package:workday/utils/statebar_util.dart';

import '../../components/container/custom_icon_button.dart';
import '../../enumm/nav_enum.dart';
import '../../utils/assert_util.dart';
import '../../utils/date_util.dart';
import 'dto/dayinfo.dart';

List<String> weekStrList = ["日", "一", "二", "三", "四", "五", "六"];

/// 顶部时间、星期
Widget dateTitleBar(BuildContext context) {
  final controller = Get.find<CalendarPageViewModel>();
  return Container(
    width: context.width,
    height: 116,
    color: const Color(0xFFF1F2F5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
          width: context.width,
          height: 86,
          child: SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 16),
                Obx(
                  () => Text(
                    "2024年${controller.currentMonth}月",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Expanded(child: SizedBox()),
                CustomIconButton(
                  AssertUtil.menuSvg,
                  padding: const EdgeInsets.all(16),
                  iconSize: 20,
                  alignment: Alignment.centerRight,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: Row(
                children: List.generate(weekStrList.length, (index) {
          return Expanded(
            child: SizedBox(
              child: Center(
                child: Text(
                  weekStrList[index],
                  style: TextStyle(
                      color: index == 0 || index == 6
                          ? const Color(0xFF727376)
                          : const Color(0xFF222326)),
                ),
              ),
            ),
          );
        }))),
        const Divider(
          height: 0.4, // 分割线容器的高度，并不是线的厚度
          thickness: 0.4, // 线的厚度
          color: Color(0xFFD2D3D6),
        ),
      ],
    ),
  );
}

/// 日历Day文本颜色
Color _dayTextColor(DateTime? nowDateTime, CalendarPageViewModel controller,
    DateTime? currentDayDateTime) {
  if (null == nowDateTime) return Colors.transparent;

  if (nowDateTime == currentDayDateTime) {
    return Colors.white;
  } else if (nowDateTime == controller.todayDateTime) {
    return Colors.red;
  } else if (nowDateTime.weekday == 6 || nowDateTime.weekday == 7) {
    return const Color(0xFF727376);
  } else {
    return Colors.black;
  }
}

/// 出勤信息
Widget _attendance(CalendarPageViewModel controller, DayInfoDTO? dayInfoDTO) {
  // 不存在的日期Item
  if (null == dayInfoDTO) {
    return const Text(
      '未选择',
      style: TextStyle(
        fontSize: 9,
        //color: Colors.amber,
        color: Colors.transparent,
      ),
    );
  }

  // 在今天之后
  if (dayInfoDTO.dateTime.isAfter(DateUtil.todayDateTime())) {
    return const Text(
      '未选择',
      style: TextStyle(
        fontSize: 9,
        //color: Colors.grey,
        color: Colors.transparent,
      ),
    );
  }

  // 未选择出勤
  if (dayInfoDTO.attendance == AttendanceEnum.unselect.attendance) {
    return const Text(
      '未选择',
      style: TextStyle(
        fontSize: 9,
        //color: Colors.red,
        color: Colors.transparent,
      ),
    );
  }

  String result = '';
  if (dayInfoDTO.attendance == 0) {
    result = '未选择';
  } else if (dayInfoDTO.attendance == 1) {
    result = '全天';
  } else if (dayInfoDTO.attendance == 2) {
    result = '上午';
  } else if (dayInfoDTO.attendance == 3) {
    result = '下午';
  }

  return Text(
    result,
    style: const TextStyle(
      fontSize: 9,
    ),
  );
}

/// 日历详情
Widget calenderInfo(
    CalendarPageViewModel controller, BuildContext context, int month) {
  const monthMaxRow = 6; // 每月最大显示行
  const weekDay = 7; // 每周天数（列）
  // 需要绘制多少行
  final shouldRow = DateUtil.calculateRowsForMonth(2024, month);
  debugPrint("month: $month  需要绘制行: $shouldRow");

  controller.initCurrentMonthInfo(2024, month);
  return SizedBox(
    child: Column(
      children: List.generate(monthMaxRow, (outRowIndex) {
        return Column(
          children: [
            Row(
              children: List.generate(
                weekDay,
                (weekColumn) {
                  final dayInfoDTO = controller.oneDayDayInfoDTO(
                      outRowIndex, weekColumn, month);
                  final dayDateTime = dayInfoDTO?.dateTime;
                  final lunarInfo = dayInfoDTO?.lunar;
                  final attendance = dayInfoDTO?.attendance;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (null != dayDateTime) {
                          controller.currentDayDateTime.value = dayDateTime;
                        }
                      },
                      child: SizedBox(
                        width: ((context.height / 2) - 116) / monthMaxRow,
                        height: ((context.height / 2) - 116) / monthMaxRow,
                        //color: Colors.amber,
                        child: Stack(
                          children: [
                            Center(
                              child: Obx(
                                () => Container(
                                  width: ((context.height / 2) - 116) /
                                      monthMaxRow,
                                  height: ((context.height / 2) - 116) /
                                      monthMaxRow,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: dayDateTime ==
                                            controller.currentDayDateTime.value
                                        ? Colors.red
                                        : const Color(0xFFF1F2F5),
                                    // border: Border.all(width: 0.1),
                                    //borderRadius: Bo,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                width:
                                    ((context.height / 2) - 116) / monthMaxRow,
                                height:
                                    ((context.height / 2) - 116) / monthMaxRow,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => Text(
                                        dayDateTime?.day.toString() ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _dayTextColor(
                                                dayDateTime,
                                                controller,
                                                controller
                                                    .currentDayDateTime.value)),
                                      ),
                                    ),

                                    _attendance(controller, dayInfoDTO),

                                    // 农历信息
                                    // Expanded(
                                    //   child: Center(
                                    //     child: Text(
                                    //       null == lunarInfo
                                    //           ? ""
                                    //           : DateUtil.getLunarDay(lunarInfo),
                                    //       style: TextStyle(
                                    //           fontSize: 10,
                                    //           color: dayDateTime?.weekday == 6 ||
                                    //                   dayDateTime?.weekday == 7
                                    //               ? const Color(0xFF727376)
                                    //               : Colors.black),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (outRowIndex < shouldRow - 1)
              const Divider(
                height: 0.4, // 分割线容器的高度，并不是线的厚度
                thickness: 0.4, // 线的厚度
                color: Color(0xFFD2D3D6),
                indent: 10,
                endIndent: 10,
              ),
          ],
        );
      }),
    ),
  );
}

/// 底部打卡信息部分
Widget workDayInfo(BuildContext context, CalendarPageViewModel controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Obx(
      () => Column(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.centerLeft,
            //color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${controller.currentDayDateTime.value.month}月${controller.currentDayDateTime.value.day}日",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B6B6D),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${DateUtil.getLunarMonth(DateUtil.dayLunar(controller.currentDayDateTime.value))}${DateUtil.getLunarDay(DateUtil.dayLunar(controller.currentDayDateTime.value))}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF737375),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          (controller.currentDayDateTime.value
                      .compareTo(DateUtil.todayDateTime()) <=
                  0)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 16, bottom: 8),
                  child: const Text(
                    "出勤",
                    style: TextStyle(color: Color(0XFF646466)),
                  ),
                )
              : const SizedBox(),
          (controller.currentDayDateTime.value
                      .compareTo(DateUtil.todayDateTime()) <=
                  0)
              ? Container(
                  width: context.width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Center(
                                  child: Text("全天"),
                                ),
                                Checkbox(
                                  value: controller.dayCheckBox.value,
                                  onChanged: (value) {
                                    controller.dayCheckBox.value = value!;
                                    controller.morningCheckBox.value = false;
                                    controller.afternoonCheckBox.value = false;
                                  },
                                  activeColor: Colors.blue,
                                  checkColor: Colors.white,
                                  tristate: false,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  visualDensity: VisualDensity.compact,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                        width: 2.0, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Center(
                                  child: Text("上午"),
                                ),
                                Checkbox(
                                  value: controller.morningCheckBox.value,
                                  onChanged: (value) {
                                    controller.dayCheckBox.value = false;
                                    controller.morningCheckBox.value = value!;
                                    controller.afternoonCheckBox.value = false;
                                  },
                                  activeColor: Colors.blue,
                                  checkColor: Colors.white,
                                  tristate: false,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  visualDensity: VisualDensity.compact,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                        width: 2.0, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Center(
                                  child: Text("下午"),
                                ),
                                Checkbox(
                                  value: controller.afternoonCheckBox.value,
                                  onChanged: (value) {
                                    controller.dayCheckBox.value = false;
                                    controller.morningCheckBox.value = false;
                                    controller.afternoonCheckBox.value = value!;
                                  },
                                  activeColor: Colors.blue,
                                  checkColor: Colors.white,
                                  tristate: false,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  visualDensity: VisualDensity.compact,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                        width: 2.0, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

class CalendarPage extends GetView<CalendarPageViewModel> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    StateBarUtil.setAndroidStateBarColor(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F5),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            // 日历详情信息
            Positioned(
              left: 0,
              right: 0,
              top: 116,
              child: SizedBox(
                width: context.width,
                height: (((context.height / 2) - 116) / 6) * 6 + 2,
                child: PageView.builder(
                  controller: controller.calendarPagerController,
                  itemCount: 12,
                  //scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return calenderInfo(controller, context, index + 1);
                  },
                  onPageChanged: (value) {
                    controller.changeCurrentMonth(value);
                  },
                ),
              ),
            ),

            // 顶部时间信息
            Align(
              alignment: Alignment.topCenter,
              child: dateTitleBar(context),
            ),

            // 底部考勤
            Obx(
              () => DraggableScrollableSheet(
                initialChildSize: 0.5, // 初始时，底部面板占据整个屏幕高度的比例
                minChildSize: (context.height -
                        116 -
                        (((context.height / 2) - 116)) -
                        (0.4 * (controller.currentRowsMonth.value - 1))) /
                    context.height, // 底部面板可以拖拽到的最小高度比例
                maxChildSize: (context.height -
                        116 -
                        (((context.height / 2) - 116) / 6)) /
                    context.height, // 底部面板可以拖拽到的最大高度比例
                controller: controller.draggableScrollableController,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Column(
                    children: [
                      const Divider(
                        height: 0.4, // 分割线容器的高度，并不是线的厚度
                        thickness: 0.4, // 线的厚度
                        color: Color(0xFFD2D3D6),
                      ),
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9FB),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            child: workDayInfo(context, controller),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            Positioned(
              right: 32,
              bottom: NavigationOptions.hight55.height + 32,
              child: CustomContainer(
                duration: const Duration(milliseconds: 200),
                scaleValue: 0.9,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  controller.scrollerToToDay();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "今",
                      style: TextStyle(
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
