import 'package:lunar_calendar_converter_new/lunar_solar_converter.dart';

class DayInfoDTO {
  // 新历时间
  late DateTime dateTime;
  // 农历时间
  late Lunar lunar;
  // 出勤
  late int attendance;

  DayInfoDTO(
      {required this.dateTime, required this.lunar, this.attendance = 0});
}
