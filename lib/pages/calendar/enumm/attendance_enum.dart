enum AttendanceEnum {
  // 未选中
  unselect(attendance: 0),
  // 全天
  allDay(attendance: 1),
  // 上午
  morning(attendance: 2),
  // 下午
  afternoon(attendance: 3),
  ;

  final int attendance;

  const AttendanceEnum({
    required this.attendance,
  });
}
