import 'package:get/get.dart';
import 'package:workday/pages/calendar/calendar_page.dart';
import 'package:workday/pages/calendar/viewdoel/calendar_page_vm.dart';
import 'package:workday/utils/page_path_util.dart';

import '../pages/nav/bottom_nav_page.dart';
import '../pages/nav/viewmodel/bnp_vm.dart';

class AppRountes {
  static List<GetPage<dynamic>>? appRoutes = [
    // APP进入主页，导航栏界面
    GetPage(
      name: PagePathUtil.bottomNavPage,
      page: () => const BottomNavPage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => BottomNavViewModel());
          Get.lazyPut(() => CalendarPageViewModel());
        },
      ),
    ),
    GetPage(
      name: PagePathUtil.calendaerPage,
      page: () => const CalendarPage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => CalendarPageViewModel());
        },
      ),
    ),
  ];
}
