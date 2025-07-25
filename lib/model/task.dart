import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime scheduledDate;

  @HiveField(4)
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.scheduledDate,
    this.isDone = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isDone: isDone ?? this.isDone,
    );
  }
}

