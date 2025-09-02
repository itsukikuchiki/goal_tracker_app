import 'package:hive/hive.dart';
import 'sub_goal.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final int priority; // 1 = 高, 2 = 中, 3 = 低

  @HiveField(6)
  final List<SubGoal> subGoals;

  @HiveField(7)
  final int colorHex; // UI显示颜色

  @HiveField(8)
  final bool isCompleted; // 是否完成

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.subGoals,
    this.colorHex = 0xFFB3E5FC, // 默认浅蓝色
    this.isCompleted = false,
  });

  factory Goal.empty() {
    return Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      description: '',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      priority: 2,
      subGoals: [],
      colorHex: 0xFFB3E5FC,
      isCompleted: false,
    );
  }

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? priority,
    List<SubGoal>? subGoals,
    int? colorHex,
    bool? isCompleted,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      subGoals: subGoals ?? this.subGoals,
      colorHex: colorHex ?? this.colorHex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}


