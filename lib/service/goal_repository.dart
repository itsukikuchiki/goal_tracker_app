import 'package:hive/hive.dart';
import '../model/goal.dart';

class GoalRepository {
  static const String goalBoxName = 'goalBox';

  Future<void> saveGoal(Goal goal) async {
    final box = await Hive.openBox<Goal>(goalBoxName);
    await box.put(goal.id, goal);
  }

  Future<List<Goal>> getAllGoals() async {
    final box = await Hive.openBox<Goal>(goalBoxName);
    return box.values.toList();
  }

  Future<void> deleteGoal(String goalId) async {
    final box = await Hive.openBox<Goal>(goalBoxName);
    await box.delete(goalId);
  }

  Future<void> clearAllGoals() async {
    final box = await Hive.openBox<Goal>(goalBoxName);
    await box.clear();
  }
}

