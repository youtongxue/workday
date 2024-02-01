/*
  @description 定义底部状态栏高度枚举类
 */
enum NavigationOptions {
  hight55(height: 55),
  hight59(height: 59);

  final double height;

  const NavigationOptions({
    required this.height,
  });
}
