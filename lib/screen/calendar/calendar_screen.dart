import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/goal.dart';
import '../../model/daily_log.dart';
import '../../provider/goal_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalListProvider);

    // 提取该日期下所有子目标
    final List<_SubGoalWithParent> daySubGoals = goals.expand((goal) {
      return goal.subGoals
          .where((sub) => !_isSubGoalCompleted(sub, _selectedDay))
          .map((sub) => _SubGoalWithParent(goal, sub));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("日历打卡"),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: daySubGoals.isEmpty
                ? const Center(child: Text("今日无待办子目标"))
                : ListView.builder(
                    itemCount: daySubGoals.length,
                    itemBuilder: (context, index) {
                      final item = daySubGoals[index];
                      return ListTile(
                        title: Text(item.subGoal.title),
                        subtitle: Text("来自目标：${item.goal.title}"),
                        trailing: const Icon(Icons.check_circle_outline),
                        onTap: () => _logTimeDialog(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 是否已经打卡
  bool _isSubGoalCompleted(subGoal, DateTime day) {
    return subGoal.logs.any((log) =>
        log.date.year == day.year &&
        log.date.month == day.month &&
        log.date.day == day.day);
  }

  void _logTimeDialog(_SubGoalWithParent item) {
    final minutesController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("为子目标打卡"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.subGoal.title),
            const SizedBox(height: 8),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "投入时间（分钟）",
              ),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "备注（可选）",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消")),
          ElevatedButton(
              onPressed: () {
                final minutes =
                    int.tryParse(minutesController.text) ?? 0;
                final note = noteController.text;

                final log = DailyLog(
                    date: _selectedDay,
                    minutesSpent: minutes,
                    note: note);

                final notifier = ref.read(goalListProvider.notifier);
                notifier.updateLog(
                  item.goal.id,
                  item.subGoal.id,
                  log,
                );

                Navigator.pop(context);
              },
              child: const Text("保存")),
        ],
      ),
    );
  }
}

// 内部辅助类，用于绑定 SubGoal 与其 Goal
class _SubGoalWithParent {
  final Goal goal;
  final dynamic subGoal;

  _SubGoalWithParent(this.goal, this.subGoal);
}

