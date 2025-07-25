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

  DailyLog({
    required this.date,
    required this.minutesSpent,
    this.note,
  });
}

