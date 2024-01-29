import 'package:get/get.dart';
import 'package:workday/pages/calendar/calendar_page.dart';
import 'package:workday/pages/calendar/calendar_page_vm.dart';
import 'package:workday/utils/page_path_util.dart';

class AppRountes {
  static List<GetPage<dynamic>>? appRoutes = [
    GetPage(
        name: PagePathUtil.calendaerPage,
        page: () => const CalendarPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => CalendarPageViewModel());
        }))
  ];
}
