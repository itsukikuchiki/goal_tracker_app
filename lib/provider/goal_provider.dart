import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/goal.dart';
import '../model/sub_goal.dart';
import '../model/daily_log.dart';
import '../service/goal_repository.dart';

final goalRepositoryProvider = Provider((ref) => GoalRepository());

final goalListProvider = StateNotifierProvider<GoalListNotifier, List<Goal>>((ref) {
  final repo = ref.read(goalRepositoryProvider);
  return GoalListNotifier(repo)..loadGoals(); // 初始加载
});

class GoalListNotifier extends StateNotifier<List<Goal>> {
  final GoalRepository repository;

  GoalListNotifier(this.repository) : super([]);

  Future<void> loadGoals() async {
    final goals = await repository.getAllGoals();
    state = goals;
  }

  Future<void> addGoal(Goal goal) async {
    await repository.saveGoal(goal);
    state = [...state, goal];
  }

  Future<void> updateGoal(Goal updated) async {
    await repository.saveGoal(updated);
    state = [
      for (final g in state) if (g.id == updated.id) updated else g,
    ];
  }

  Future<void> deleteGoal(String id) async {
    await repository.deleteGoal(id);
    state = state.where((g) => g.id != id).toList();
  }

  Future<void> clearAll() async {
    await repository.clearAllGoals();
    state = [];
  }
  
  Future<void> updateLog(String goalId, String subGoalId, DailyLog log) async {
   final updatedGoals = state.map((goal) {
     if (goal.id != goalId) return goal;

     final updatedSubGoals = goal.subGoals.map((sub) {
       if (sub.id != subGoalId) return sub;
       return SubGoal(
         id: sub.id,
         goalId: sub.goalId,
         title: sub.title,
         dueDate: sub.dueDate,
         estimatedMinutes: sub.estimatedMinutes,
         isCompleted: sub.isCompleted,
         logs: [...sub.logs, log]..sort((a, b) => a.date.compareTo(b.date)),
       );
     }).toList();

     return Goal(
       id: goal.id,
       title: goal.title,
       description: goal.description,
       startDate: goal.startDate,
       endDate: goal.endDate,
       priority: goal.priority,
       subGoals: updatedSubGoals,
     );
   }).toList();

   state = updatedGoals;
   await repository.saveGoal(state.firstWhere((g) => g.id == goalId));
  }
}

