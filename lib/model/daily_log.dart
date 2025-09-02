import 'package:hive/hive.dart';

part 'daily_log.g.dart';

@HiveType(typeId: 0)
class DailyLog {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int minutesSpent;

  @HiveField(2)
  final String? note;

  @HiveField(3)
  final String subGoalId; // 新增字段

  DailyLog({
    required this.date,
    required this.minutesSpent,
    this.note,
    this.subGoalId = '',
  });
}

