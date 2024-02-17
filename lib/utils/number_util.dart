class NumberUtil {
  static String formatNumber(double number) {
    // 如果数字的小数部分为0，则转换为整数字符串，否则保留一位小数
    return number % 1 == 0
        ? number.toInt().toString()
        : number.toStringAsFixed(1);
  }
}
