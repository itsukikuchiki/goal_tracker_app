import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../provider/goal_provider.dart';
import '../../screen/goal/goal_edit_screen.dart';
import '../../model/goal.dart';
import '../../model/daily_log.dart';
import '../../widget/progress_ring.dart';
import '../../widget/sub_goal_list.dart';

class GoalCard extends ConsumerWidget {
  final Goal goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bgColor = Color(goal.colorHex);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GoalEditScreen(goal: goal)),
        );
      },
      child: Opacity(
        opacity: goal.isCompleted ? 0.5 : 1.0,
        child: Card(
          color: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (goal.isCompleted)
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          if (goal.isCompleted) const SizedBox(width: 4),
                          Text(
                            goal.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProgressRing(percentage: _calculateProgress(goal)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("截止：${goal.endDate.toLocal().toString().split(' ')[0]}", style: theme.textTheme.bodySmall),
                Text("优先级：${_priorityText(goal.priority)}", style: theme.textTheme.bodySmall),
                Text("子目标数：${goal.subGoals.length}", style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),
                SubGoalList(goalId: goal.id),
                const SizedBox(height: 16),
                if (goal.subGoals.any((sg) => sg.logs.isNotEmpty))
                  SizedBox(height: 200, child: BurndownChart(goal: goal)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!goal.isCompleted)
                      TextButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('完成'),
                        onPressed: () async {
                          final updated = Goal(
                            id: goal.id,
                            title: goal.title,
                            description: goal.description,
                            startDate: goal.startDate,
                            endDate: goal.endDate,
                            priority: goal.priority,
                            subGoals: goal.subGoals.map((s) => s.copyWith(isCompleted: true)).toList(),
                            colorHex: goal.colorHex,
                            isCompleted: true,
                          );
                          await ref.read(goalListProvider.notifier).updateGoal(updated);
                        },
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateProgress(Goal goal) {
    if (goal.subGoals.isEmpty) return 0;
    final completed = goal.subGoals.where((s) => s.isCompleted).length;
    return completed / goal.subGoals.length;
  }

  String _priorityText(int priority) {
    switch (priority) {
      case 3:
        return '高';
      case 2:
        return '中';
      case 1:
        return '低';
      default:
        return '未知';
    }
  }
}

class BurndownChart extends StatelessWidget {
  final Goal goal;
  const BurndownChart({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final start = goal.startDate;
    final end = goal.endDate;
    final totalDays = end.difference(start).inDays + 1;

    final dailyTotals = <int, int>{};
    for (final sub in goal.subGoals) {
      for (final log in sub.logs) {
        final dayOffset = log.date.difference(start).inDays;
        if (dayOffset >= 0 && dayOffset <= totalDays) {
          dailyTotals.update(dayOffset, (v) => v + log.minutesSpent,
              ifAbsent: () => log.minutesSpent);
        }
      }
    }

    int remaining = goal.subGoals.fold(
        0, (sum, sub) => sum + sub.estimatedMinutes);
    final actualData = <FlSpot>[];
    final idealData = <FlSpot>[];

    for (int day = 0; day <= totalDays; day++) {
      if (day > 0) {
        remaining -= (dailyTotals[day - 1] ?? 0);
      }
      actualData.add(FlSpot(day.toDouble(), remaining.toDouble()));
      final idealRemaining = goal.subGoals.fold(
            0, (sum, sub) => sum + sub.estimatedMinutes,
          ) * (1 - day / totalDays);
      idealData.add(FlSpot(day.toDouble(), idealRemaining));
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: idealData,
            isCurved: false,
            color: Colors.grey,
            dotData: FlDotData(show: false),
            dashArray: [4, 4],
          ),
          LineChartBarData(
            spots: actualData,
            isCurved: true,
            color: Colors.red,
            dotData: FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

extension on SubGoal {
  SubGoal copyWith({bool? isCompleted}) {
    return SubGoal(
      id: id,
      goalId: goalId,
      title: title,
      startTime: startTime,
      endTime: endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      logs: logs,
    );
  }
}

