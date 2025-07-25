import 'package:hive/hive.dart';
import 'daily_log.dart';

part 'sub_goal.g.dart';

@HiveType(typeId: 1)
class SubGoal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String goalId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final int estimatedMinutes;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final List<DailyLog> logs;

  SubGoal({
    required this.id,
    required this.goalId,
    required this.title,
    required this.dueDate,
    required this.estimatedMinutes,
    required this.isCompleted,
    required this.logs,
  });
}

