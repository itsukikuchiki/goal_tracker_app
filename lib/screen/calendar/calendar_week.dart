// lib/screen/calendar/calendar_week.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../provider/task_provider.dart';
import '../../model/task.dart';

class CalendarWeekScreen extends ConsumerStatefulWidget {
  const CalendarWeekScreen({super.key});

  @override
  ConsumerState<CalendarWeekScreen> createState() => _CalendarWeekScreenState();
}

class _CalendarWeekScreenState extends ConsumerState<CalendarWeekScreen> {
  DateTime _selectedDate = DateTime.now();

  List<DateTime> _generateWeekDays(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskListProvider);
    final weekDays = _generateWeekDays(_selectedDate);
    final formatter = DateFormat('MM/dd');

    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDays.length,
            itemBuilder: (context, index) {
              final day = weekDays[index];
              final isSelected = isSameDay(day, _selectedDate);
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = day),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        formatter.format(day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: _buildTaskListForDay(_selectedDate, allTasks),
        ),
      ],
    );
  }

  Widget _buildTaskListForDay(DateTime day, List<Task> allTasks) {
    final tasksForDay = allTasks.where((task) => isSameDay(task.scheduledDate, day)).toList();

    if (tasksForDay.isEmpty) {
      return const Center(child: Text('この日に予定はありません'));
    }

    return ListView.builder(
      itemCount: tasksForDay.length,
      itemBuilder: (context, index) {
        final task = tasksForDay[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

