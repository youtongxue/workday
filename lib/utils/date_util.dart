import 'package:date_format/date_format.dart';

class DateUtil {
  DateUtil._();

  // 计算两个年份之间的所有年份值
  static List<int> getBetweenYear(
      {required int startYear, required int endYear}) {
    List<int> years = [];
    for (int year = startYear; year <= endYear; year++) {
      years.add(year);
    }
    return years;
  }

  // 返回所有月份
  static List<int> getAllMonthList() {
    return const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  }

  // 计算某年某月，所有日值
  static List<int> getYMdays({required int year, required int month}) {
    List<int> days = [];

    int daysInMonth = DateTime.utc(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime.utc(year, month, i);

      final formattedDate = int.parse(formatDate(date.toLocal(), [d],
          locale: const SimplifiedChineseDateLocale())); // 将日期转换为中国时间

      days.add(formattedDate);
    }

    return days;
  }

  /// 返回指定年月的第一天是星期几
  ///
  /// [year] 表示年份，[month] 表示月份
  /// 返回值是一个整数，0 表示星期日，1 表示星期一，依此类推，直到 6 表示星期六
  static int firstDayOfWeek(int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    return firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
  }

  /// 返回指定年月的天数
  ///
  /// [year] 表示年份，[month] 表示月份
  /// 返回值是一个整数，表示该月的天数
  static int getDaysInMonth(int year, int month) {
    // 计算下一个月的第一天
    DateTime firstDayOfNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    // 下一个月的第一天减去一天，得到当前月的最后一天
    DateTime lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));

    // 返回当前月的天数
    return lastDayOfMonth.day;
  }

  /// 计算某个月按照【日、一、二、三、四、五、六】显示，需要显示多少行
  static int calculateRowsForMonth(int year, int month) {
    // 获取该月的第一天
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    // 获取该月的最后一天（下个月的第一天的前一天）
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    // 计算该月的第一天是星期几（0代表星期日，1代表星期一，...，6代表星期六）
    int weekdayOfFirstDay = firstDayOfMonth.weekday % 7;

    // 计算该月的天数
    int daysInMonth = lastDayOfMonth.day;

    // 计算需要的行数
    // 第一行包含第一天和它之前的几天（如果第一天不是星期日）
    // 剩余的天数除以7得到完整的星期数
    // 如果还有剩余的天数，则需要额外一行
    int fullWeeks = (daysInMonth + weekdayOfFirstDay) ~/ 7;
    int remainingDays = (daysInMonth + weekdayOfFirstDay) % 7;
    int rows = fullWeeks + (remainingDays > 0 ? 1 : 0);

    return rows;
  }

  /// 某月分的某天信息
  static List<DateTime> dayInfoInMonth(int year, int month) {
    List<DateTime> daysInMonth = [];
    // 获取该月的第一天
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    // 获取下一个月的第一天
    DateTime firstDayOfNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    // 当前遍历的日期
    DateTime currentDay = firstDayOfMonth;
    // 遍历该月的每一天
    while (currentDay.isBefore(firstDayOfNextMonth)) {
      // 将当前日期添加到列表中
      daysInMonth.add(currentDay);
      // 移动到下一天
      currentDay = currentDay.add(const Duration(days: 1));
    }

    return daysInMonth;
  }
}
