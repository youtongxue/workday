import 'package:date_format/date_format.dart';
import 'package:lunar_calendar_converter_new/lunar_solar_converter.dart';

class DateUtil {
  // 创建一个数组来存储农历月份的名字
  static final List<String> _lunarMonth = [
    '正月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '冬月',
    '腊月'
  ];

  // 创建一个数组来存储农历日期的名字
  static final List<String> _lunarDay = [
    '初一',
    '初二',
    '初三',
    '初四',
    '初五',
    '初六',
    '初七',
    '初八',
    '初九',
    '初十',
    '十一',
    '十二',
    '十三',
    '十四',
    '十五',
    '十六',
    '十七',
    '十八',
    '十九',
    '二十',
    '廿一',
    '廿二',
    '廿三',
    '廿四',
    '廿五',
    '廿六',
    '廿七',
    '廿八',
    '廿九',
    '三十'
  ];

  static const List<String> tianGan = [
    '甲',
    '乙',
    '丙',
    '丁',
    '戊',
    '己',
    '庚',
    '辛',
    '壬',
    '癸'
  ];
  static const List<String> diZhi = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥'
  ];
  static const List<String> shengXiao = [
    '鼠',
    '牛',
    '虎',
    '兔',
    '龙',
    '蛇',
    '马',
    '羊',
    '猴',
    '鸡',
    '狗',
    '猪'
  ];

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

  /// 获取某个DateTime的农历信息
  static List<Lunar> dayLunarInMonth(List<DateTime> dateTimeList) {
    List<Lunar> lunarInfoList = [];

    for (var dateTime in dateTimeList) {
      Solar solar = Solar(
          solarYear: dateTime.year,
          solarMonth: dateTime.month,
          solarDay: dateTime.day);
      Lunar lunar = LunarSolarConverter.solarToLunar(solar);

      lunarInfoList.add(lunar);
    }

    return lunarInfoList;
  }

  /// 获取某个DateTime的农历信息
  static Lunar dayLunar(DateTime dateTime) {
    Solar solar = Solar(
        solarYear: dateTime.year,
        solarMonth: dateTime.month,
        solarDay: dateTime.day);
    Lunar lunar = LunarSolarConverter.solarToLunar(solar);

    return lunar;
  }

  /// 获取农历天信息
  static String getLunarDay(Lunar lunar) {
    return _lunarDay[lunar.lunarDay! - 1];
  }

  /// 获取农历天信息
  static String getLunarMonth(Lunar lunar) {
    return _lunarMonth[lunar.lunarMonth! - 1];
  }

  /// 今天
  static DateTime todayDateTime() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  /// 生成ID 2024211
  static String generationDayId(DateTime dateTime) {
    String year = '${dateTime.year}';
    String month = '${dateTime.month}'.padLeft(2, '0');
    String day = '${dateTime.day}'.padLeft(2, '0');

    return '$year$month$day';
  }

  /// 生成 202401
  static String generationYearMonth(DateTime dateTime) {
    String year = '${dateTime.year}';
    String month = '${dateTime.month}'.padLeft(2, '0');

    return '$year$month';
  }

  /// 计算某一年有多少天
  static int daysInYear(int year) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      // 闰年有366天
      return 366;
    } else {
      // 平年有365天
      return 365;
    }
  }

  /// 获取某年的第一天的DateTime对象
  static DateTime firstDayOfYear(int year) {
    return DateTime(year, 1, 1);
  }

  /// 获取某年，每个月第一天的DateTime
  static List<DateTime> getFirstDaysOfMonthsInYear(int year) {
    List<DateTime> firstDays = [];
    for (int month = 1; month <= 12; month++) {
      firstDays.add(DateTime(year, month, 1));
    }
    return firstDays;
  }

  /// 获取中国传统的干支纪年体系
  static String getGanZhiYear(int year) {
    // 干支纪年从公元前2697年开始，即黄帝元年为甲子年
    // 由于是循环的，可以通过取模来计算
    int ganIndex = (year - 4) % 10; // 天干是十年一个循环
    int zhiIndex = (year - 4) % 12; // 地支是十二年一个循环

    // 获取对应的天干、地支
    String gan = tianGan[ganIndex];
    String zhi = diZhi[zhiIndex];

    // 获取对应的生肖
    String xiao = shengXiao[zhiIndex];

    // 拼接结果
    return '$gan$zhi$xiao年';
  }

  /// 闰年
  static bool isRunYear(int year) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      // 闰年有366天
      return true;
    } else {
      // 平年有365天
      return false;
    }
  }

  /// 加减一年
  static DateTime addOrSubtractYear(DateTime date, int years) {
    int newYear = date.year + years;
    int newMonth = date.month;
    int newDay = date.day;

    // 检查是否是2月29日且目标年份不是闰年
    if (newMonth == 2 && newDay == 29 && !isRunYear(date.year)) {
      // 将日期调整为2月28日
      newDay = 28;
    }

    return DateTime(newYear, newMonth, newDay);
  }
}
