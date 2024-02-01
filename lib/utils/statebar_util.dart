import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StateBarUtil {
  StateBarUtil._();
  /*
   * 设置Android设备的状态栏背景色、Icon颜色【深色】、【亮色】
   */
  static Future<void> setAndroidStateBarColor({
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
  }) async {
    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle style = SystemUiOverlayStyle(
          // 状态栏背景色
          statusBarColor: statusBarColor,
          // 设置状态栏的图标和字体颜色，light 白色， dark 黑色
          statusBarIconBrightness: statusBarIconBrightness);
      SystemChrome.setSystemUIOverlayStyle(style);
      debugPrint('设置状态栏背景色: $statusBarColor  图标色: $statusBarIconBrightness');
    }

    /*
     * 设置iOS设备状态栏的颜色
     * statusBarColor只在Android设备上有效，iOS设备上的状态栏背景颜色总是透明的
     * statusBarIconBrightness参数在iOS设备上只影响时间和电池图标的颜色
     * 其他图标的颜色是由应用的信息plist文件决定的
     */
  }
}
