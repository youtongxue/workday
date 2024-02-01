/*
  @descripton 定义状态栏高度枚举类
 */
enum AppBarOptions {
  hight50(height: 50),
  hight100(height: 100);

  final double height;

  const AppBarOptions({
    required this.height,
  });
}
