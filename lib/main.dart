import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'rountes/app_rountes.dart';
import 'services/init_service.dart';
import 'utils/page_path_util.dart';

void main() async {
  // 全局初始化
  await InitService.init();
  runApp(const WejindaApp());
}

class WejindaApp extends StatelessWidget {
  const WejindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // navigatorKey: Toast.navigatorKey, //加上此配置
      //navigatorObservers: [FlutterSmartDialog.observer],
      // Dialog 初始化
      builder: FlutterSmartDialog.init(),
      initialRoute: PagePathUtil.bottomNavPage,
      getPages: AppRountes.appRoutes,
      defaultTransition: Transition.native, // 页面跳转默认动画
      //routingCallback: RoutingListener.routingListner,
      theme: ThemeData(platform: TargetPlatform.iOS),
    );
  }
}
