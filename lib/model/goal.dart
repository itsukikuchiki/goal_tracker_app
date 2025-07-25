import 'package:hive/hive.dart';
import 'sub_goal.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal {
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
  final int priority;

  @HiveField(6)
  final List<SubGoal> subGoals;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.subGoals,
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
    );
  }
}

