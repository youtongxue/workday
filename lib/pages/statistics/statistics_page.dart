import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workday/components/view/custom_body.dart';
import 'package:workday/enumm/color_enum.dart';
import 'package:workday/enumm/nav_enum.dart';
import 'package:workday/utils/date_util.dart';
import 'package:workday/utils/number_util.dart';

import 'statistics_page_vm.dart';

class StatisticsPage extends GetView<StatisticsPageViewModel> {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        scroller: false,
        enableAppBarPadding: false,
        backgroundColor: MyColors.background.color,
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: Column(
            children: [
              SizedBox(
                height: context.mediaQueryPadding.top,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                //color: Colors.white,
                //height: 300,
                width: context.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        '${controller.calendarPageViewModel.currentYear}年',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(() => Text(
                          '${DateUtil.getGanZhiYear(controller.calendarPageViewModel.currentYear.value)} ${DateUtil.isRunYear(controller.calendarPageViewModel.currentYear.value) ? '闰' : '平'}年',
                          style: const TextStyle(color: Colors.black54),
                        )),
                    const SizedBox(height: 6),
                    Obx(() => Text(
                          '出勤日长：${NumberUtil.formatNumber(controller.yearStatisticsDay.value)}天',
                          style: const TextStyle(color: Colors.black54),
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.needShowMonthCount.value,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 50,
                        margin: EdgeInsets.only(
                            left: 12,
                            top: index == 0 ? 12 : 0,
                            right: 12,
                            bottom: 12),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Center(
                                child: Text(
                                  '${index + 1} 月',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor:
                                        controller.dayInMonthList[index] /
                                            31, // 这里设置宽度的百分比，例如这里是50%
                                    child: Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: MyColors.background1.color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor:
                                        controller.statisticsDayInMonth[index] /
                                            31, // 这里设置宽度的百分比，例如这里是50%
                                    child: Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: MyColors.cardGreen.color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Center(
                                child: Text(
                                  '${NumberUtil.formatNumber(controller.statisticsDayInMonth[index])}天',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: NavigationOptions.hight55.height),
            ],
          ),
        ),
      ),
    );
  }
}
