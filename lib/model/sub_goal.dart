import 'package:hive/hive.dart';
import 'daily_log.dart';

part 'sub_goal.g.dart';

@HiveType(typeId: 1)
class SubGoal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String goalId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime endTime;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final List<DailyLog> logs;

  SubGoal({
    required this.id,
    required this.goalId,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
    this.logs = const [],
  });

  /// 子目标预估时长（分钟）
  int get estimatedMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// 实际投入时间（分钟）
  int get actualMinutes {
    return logs.fold(0, (sum, log) => sum + log.minutesSpent);
  }

  /// 进度比（0.0～1.0）
  double get progressRatio {
    if (estimatedMinutes == 0) return 0.0;
    return (actualMinutes / estimatedMinutes).clamp(0.0, 1.0);
  }

  /// ✅ copyWith 方法
  SubGoal copyWith({
    String? id,
    String? goalId,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    List<DailyLog>? logs,
  }) {
    return SubGoal(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      logs: logs ?? List.from(this.logs),
    );
  }
}

