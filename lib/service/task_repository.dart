import 'package:hive/hive.dart';
import '../model/task.dart';

class TaskRepository {
  static const String taskBoxName = 'taskBox';

  Future<void> saveTask(Task task) async {
    final box = await Hive.openBox<Task>(taskBoxName);
    await box.put(task.id, task);
  }

  Future<List<Task>> getAllTasks() async {
    final box = await Hive.openBox<Task>(taskBoxName);
    return box.values.toList();
  }

  Future<void> deleteTask(String taskId) async {
    final box = await Hive.openBox<Task>(taskBoxName);
    await box.delete(taskId);
  }

  Future<void> clearAllTasks() async {
    final box = await Hive.openBox<Task>(taskBoxName);
    await box.clear();
  }
}

