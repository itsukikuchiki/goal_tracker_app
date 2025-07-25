// lib/screen/calendar/calendar_month.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../provider/task_provider.dart';
import '../../model/task.dart';

class CalendarMonthScreen extends ConsumerStatefulWidget {
  const CalendarMonthScreen({super.key});

  @override
  ConsumerState<CalendarMonthScreen> createState() => _CalendarMonthScreenState();
}

class _CalendarMonthScreenState extends ConsumerState<CalendarMonthScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskListProvider);
    final todayTasks = allTasks.where((task) {
      return isSameDay(task.scheduledDate, _selectedDay);
    }).toList();

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(formatButtonVisible: false),
        ),
        const Divider(),
        Expanded(
          child: todayTasks.isEmpty
              ? const Center(child: Text('この日に予定はありません'))
              : ListView.builder(
                  itemCount: todayTasks.length,
                  itemBuilder: (context, index) {
                    final task = todayTasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.description),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

