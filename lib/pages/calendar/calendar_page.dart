import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workday/enumm/color_enum.dart';
import 'package:workday/pages/calendar/viewdoel/calendar_page_vm.dart';
import 'package:workday/utils/statebar_util.dart';

import '../../components/container/custom_icon_button.dart';
import '../../utils/assert_util.dart';
import '../../utils/date_util.dart';
import '../../utils/page_path_util.dart';

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

String buildDateDay(
    int monthFirstDayIsWeek, int monthDay, int column, int row) {
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

/// 日历详情
Widget calenderInfo(BuildContext context, int month) {
  const monthMaxRow = 6; // 每月最大显示行
  const weekDay = 7; // 每周天数（列）
  // 月份第一个月星期几
  final firstDayOfWeek = DateUtil.firstDayOfWeek(2024, month);
  // 某月有多少天
  final monthDay = DateUtil.getDaysInMonth(2024, month);
  // 需要绘制多少行
  final row = DateUtil.calculateRowsForMonth(2024, month);
  // 月份日期信息
  final dayInMonth = DateUtil.dayInfoInMonth(2024, month);

  debugPrint("month: $month  行: $row");

  return SizedBox(
    child: Column(
      children: List.generate(row, (column) {
        return Column(
          children: [
            Row(
              children: List.generate(weekDay, (row) {
                return Expanded(
                    child: Container(
                  height: ((context.height / 2) - 116) / monthMaxRow,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F2F5),
                    // border: Border.all(width: 0.1),
                  ),
                  child: Center(
                    child: Text(
                        buildDateDay(firstDayOfWeek, monthDay, column, row)),
                  ),
                ));
              }),
            ),
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
Widget workDayInfo(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: context.width,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              SizedBox(width: 12),
              Text(
                "出勤 : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
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
                height: (((context.height / 2) - 116) / 6) * 7,
                child: PageView.builder(
                  itemCount: 12,
                  //scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return calenderInfo(context, index + 1);
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
            DraggableScrollableSheet(
              initialChildSize: 0.5, // 初始时，底部面板占据整个屏幕高度的比例
              minChildSize:
                  (context.height - 116 - (((context.height / 2) - 116))) /
                      context.height, // 底部面板可以拖拽到的最小高度比例
              maxChildSize:
                  (context.height - 116 - (((context.height / 2) - 116) / 6)) /
                      context.height, // 底部面板可以拖拽到的最大高度比例
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const PageScrollPhysics(),
                    child: workDayInfo(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
