import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task.dart';
import '../service/task_repository.dart';

/// 提供 TaskRepository 实例
final taskRepositoryProvider = Provider((ref) => TaskRepository());

/// 提供 Task 状态列表和操作方法
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final repo = ref.read(taskRepositoryProvider);
  return TaskListNotifier(repo)..loadTasks();
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  final TaskRepository repository;

  TaskListNotifier(this.repository) : super([]);

  /// 初始化加载所有任务
  Future<void> loadTasks() async {
    final tasks = await repository.getAllTasks();
    state = tasks;
  }

  /// 添加新任务
  Future<void> addTask(Task task) async {
    await repository.saveTask(task);
    state = [...state, task];
  }

  /// 更新任务
  Future<void> updateTask(Task updated) async {
    await repository.saveTask(updated);
    state = [
      for (final t in state) if (t.id == updated.id) updated else t,
    ];
  }

  /// 删除任务
  Future<void> deleteTask(String id) async {
    await repository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  /// 清空所有任务
  Future<void> clearAll() async {
    await repository.clearAllTasks();
    state = [];
  }

  /// 根据日期筛选任务（可选）
  List<Task> getTasksForDate(DateTime date) {
    return state.where((t) => isSameDay(t.scheduledDate, date)).toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

