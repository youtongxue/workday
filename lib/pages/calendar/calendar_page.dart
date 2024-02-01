import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workday/enumm/color_enum.dart';
import 'package:workday/pages/calendar/calendar_page_vm.dart';
import 'package:workday/utils/statebar_util.dart';

import '../../components/container/custom_icon_button.dart';
import '../../utils/assert_util.dart';
import '../../utils/page_path_util.dart';

List<String> weekStrList = ["一", "二", "三", "四", "五", "六", "日"];

/// 顶部时间、星期
Widget dateTitleBar(BuildContext context) {
  return Container(
    width: context.width,
    height: 116,
    color: Colors.white,
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
                const Text(
                  "2024年2月",
                  style: TextStyle(fontSize: 18),
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
                child: Text(weekStrList[index]),
              ),
            ),
          );
        }))),
      ],
    ),
  );
}

/// 日历详情
Widget calenderInfo(BuildContext context) {
  const monthInfoRow = 1; // 月信息，占一行
  const monthMaxRow = 6; // 每月最大显示行
  const weekDay = 7; // 每周天数（列）
  return SizedBox(
    child: Column(
      children: List.generate(monthMaxRow + monthInfoRow, (column) {
        return Row(
          children: List.generate(weekDay, (row) {
            return Expanded(
                child: Container(
              height: ((context.height / 2) - 116) / 6,
              decoration:
                  BoxDecoration(color: Colors.white, border: Border.all()),
              child: Center(
                child: Text(
                    column == 0 ? "2月" : ((column - 1) * 7 + row).toString()),
              ),
            ));
          }),
        );
      }),
    ),
  );
}

/// 底部打卡信息部分
Widget workDayInfo(BuildContext context) {
  return Container(
    width: context.width,
    height: context.height / 2,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: MyColors.background.color,
    child: Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: context.width,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: const Row(
            children: [
              SizedBox(width: 12),
              Text("出勤 : "),
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
      backgroundColor: MyColors.background.color,
      body: Container(
        width: context.width,
        height: context.height,
        color: Colors.amber,
        child: Stack(
          children: [
            // 日历详情信息
            Positioned(
              left: 0,
              right: 0,
              top: 116 - (((context.height / 2) - 116) / 6),
              child: SizedBox(
                width: context.width,
                height: (((context.height / 2) - 116) / 6) * 7,
                child: PageView.builder(
                  itemCount: 12,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return calenderInfo(context);
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
            Align(
              alignment: Alignment.bottomCenter,
              child: workDayInfo(context),
            )
          ],
        ),
      ),
    );
  }
}
