import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workday/pages/calendar/calendar_page.dart';
import 'package:workday/pages/calendar/dto/dayinfo_db.dart';

import '../../../components/keep_alive_wrapper.dart';
import '../../../utils/assert_util.dart';
import '../../statistics/statistics_page.dart';
import '../../statistics/statistics_page_vm.dart';
import '../vo/nav_item.dart';

class BottomNavViewModel extends GetxController {
  final statisticsPageViewModel = Get.find<StatisticsPageViewModel>();

  late Database? db;
  // ViewPageController默认选中第一页
  final pageController = PageController(initialPage: 0);

  // PagerView 中加载的页面
  final pagerList = const [
    KeepAliveWrapper(child: CalendarPage()),
    KeepAliveWrapper(child: StatisticsPage()),
  ];

  // 底部导航栏 Item
  final bottomNavItems = [
    BottomNavItem("出勤", AssertUtil.iconCourse, () {}, isSelected: true).obs,
    BottomNavItem("统计", AssertUtil.iconMy, () {}).obs,
  ];

  // 点击底部导航栏Item时，将对应的Item设为选中状态
  void selectBottomNavItem(Rx<BottomNavItem> currentItem) {
    var currentPageIndex = pageController.page;
    var netPageIndex = bottomNavItems.indexOf(currentItem);
    if ((currentPageIndex! - netPageIndex).abs() != 1) {
      pageController.jumpToPage(netPageIndex);
    } else {
      // 让ViewPager滑动到选中页面
      pageController.animateToPage(
        netPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );

      if (netPageIndex == 1) {
        statisticsPageViewModel.refreshData();
      }
    }

    // 更改 ItemModel 状态
    for (var item in bottomNavItems) {
      item.update((oldItem) {
        oldItem?.isSelected = (item == currentItem);
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (DayInfoProvider.instance.db.isOpen) {
      db?.close();
    }
  }
}
