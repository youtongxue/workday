import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utils/date_util.dart';

const String tableDayInfo = 'day_info';
const String columnDayId = 'id';
const String columnAttendance = 'attendance';

class DayInfoDateBase {
  late String id;
  late int attendance;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnDayId: id, columnAttendance: attendance};
    return map;
  }

  DayInfoDateBase({required this.id, required this.attendance});

  DayInfoDateBase.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnDayId].toString();
    attendance = int.parse(map[columnAttendance].toString());
  }
}

class DayInfoProvider {
  static final DayInfoProvider _instance = DayInfoProvider._internal();
  late Database db;

  // 私有的构造函数
  DayInfoProvider._internal();

  // 工厂构造函数返回单例
  factory DayInfoProvider() {
    return _instance;
  }

  static DayInfoProvider get instance => _instance;

  Future open() async {
    // 获取数据库路径
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/demo.db';

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableDayInfo ( 
  $columnDayId text primary key, 
  $columnAttendance integer not null)
''');
      },
    );

    debugPrint('数据库创建打开（创建）成功 path: $path');
  }

  /// 增加
  Future<DayInfoDateBase> insert(DayInfoDateBase dayInfo) async {
    await db.insert(tableDayInfo, dayInfo.toMap());
    debugPrint('插入数据: ${dayInfo.id} 出勤: ${dayInfo.attendance}');
    return dayInfo;
  }

  /// 查询
  Future<DayInfoDateBase?> getDayInfo(String id) async {
    List<Map> maps = await db.query(tableDayInfo,
        columns: [columnDayId, columnAttendance],
        where: '$columnDayId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return DayInfoDateBase.fromMap(maps.first);
    }
    return null;
  }

  /// 根据年份查询
  Future<List<DayInfoDateBase>> getYearInfo(DateTime dateTime) async {
    List<DayInfoDateBase> data = [];
    // 将年份转换为字符串
    String yearPrefix = dateTime.year.toString();

    // 使用LIKE操作符查询以年份开头的数据
    List<Map> maps = await db.query(tableDayInfo,
        columns: [columnDayId, columnAttendance],
        where: '$columnDayId LIKE ?',
        whereArgs: ['$yearPrefix%']);

    if (maps.isNotEmpty) {
      for (var dayInfo in maps) {
        data.add(DayInfoDateBase.fromMap(dayInfo));
      }
    }

    return data;
  }

  /// 根据年月份查询
  Future<List<DayInfoDateBase>> getYearMonthInfo(DateTime dateTime) async {
    List<DayInfoDateBase> data = [];

    // 将年份转换为字符串
    String yearMonthPrefix = DateUtil.generationYearMonth(dateTime);

    // 使用LIKE操作符查询以年月份开头的数据
    List<Map> maps = await db.query(tableDayInfo,
        columns: [columnDayId, columnAttendance],
        where: '$columnDayId LIKE ?',
        whereArgs: ['$yearMonthPrefix%']);

    if (maps.isNotEmpty) {
      for (var dayInfo in maps) {
        data.add(DayInfoDateBase.fromMap(dayInfo));
      }
    }

    return data;
  }

  /// 删除
  Future<int> delete(String id) async {
    return await db
        .delete(tableDayInfo, where: '$columnDayId = ?', whereArgs: [id]);
  }

  /// 更新
  Future<int> update(DayInfoDateBase dayInfo) async {
    return await db.update(tableDayInfo, dayInfo.toMap(),
        where: '$columnDayId = ?', whereArgs: [dayInfo.id]);
  }

  /// 关闭数据库
  Future close() async => db.close();
}
