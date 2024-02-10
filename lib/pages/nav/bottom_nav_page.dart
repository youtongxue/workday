import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../../enumm/nav_enum.dart';
import 'viewmodel/bnp_vm.dart';
import 'vo/nav_item.dart';

// 底部导航栏Item
Widget navItem(Rx<BottomNavItem> item) {
  final controller = Get.find<BottomNavViewModel>();
  return Expanded(
    child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.selectBottomNavItem(item);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => SvgPicture.asset(
                item.value.assertIcon,
                width: 30,
                height: 30,
                colorFilter: item.value.isSelected
                    ? ColorFilter.mode(MyColors.iconBlue.color, BlendMode.srcIn)
                    : null,
              ),
            ),
            Obx(() => Text(
                  item.value.text,
                  style: TextStyle(
                      color: item.value.isSelected
                          ? MyColors.iconBlue.color
                          : MyColors.iconGrey1.color,
                      fontSize: 12),
                )),
          ],
        ),
      ),
    ),
  );
}

class BottomNavPage extends GetView<BottomNavViewModel> {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        // fix 此处使用padding.bottom 会造成iOS在App预览Card状态时，底部无内容
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        color: Colors.white,
        child: Stack(
          children: [
            // https://juejin.cn/post/6844903791972581390#comment 保存页面状态
            // ViewPager
            Align(
              alignment: Alignment.topCenter,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(), // 禁止滑动
                controller: controller.pageController,
                children: controller.pagerList,
              ),
            ),

            // 底部导航栏
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  const Divider(
                    height: 0.4, // 分割线容器的高度，并不是线的厚度
                    thickness: 0.4, // 线的厚度
                    color: Color(0xFFD2D3D6),
                  ),
                  Container(
                    width: context.width,
                    height: NavigationOptions.hight55.height,
                    color: const Color(0xFFFAFAFA),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: controller.bottomNavItems.map((item) {
                        return navItem(item);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
