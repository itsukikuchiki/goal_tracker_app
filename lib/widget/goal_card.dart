import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/goal.dart';
import '../../model/sub_goal.dart';
import '../../provider/goal_provider.dart';
import '../../screen/goal/goal_edit_screen.dart';
import '../../widget/progress_ring.dart';
import '../../widget/sub_goal_list.dart';

class GoalCard extends ConsumerWidget {
  final Goal goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Color(goal.colorHex),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: 标题 + 进度环 + 删除按钮
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                ProgressRing(percentage: _calculateProgress(goal)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteGoal(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              "截止：${goal.endDate.toLocal().toString().split(' ')[0]}",
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
            ),
            Text(
              "优先级：${_priorityText(goal.priority)}",
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
            ),
            Text(
              "子目标数：${goal.subGoals.length}",
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
            ),

            const SizedBox(height: 12),

            ...goal.subGoals.map((sub) => ListTile(
                  title: Text(sub.title),
                  subtitle: Text(
                    "${sub.startTime.toLocal().toString().split(' ')[0]} ~ ${sub.endTime.toLocal().toString().split(' ')[0]}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.black54),
                    onPressed: () => _removeSubGoal(ref, sub),
                  ),
                )),

            const SizedBox(height: 8),

            OutlinedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("编辑目标"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GoalEditScreen(goal: goal),
                ),
              ),
            ),

            if (goal.subGoals.any((sg) => sg.logs.isNotEmpty)) ...[
              const SizedBox(height: 16),
              SizedBox(height: 200, child: BurndownChart(goal: goal)),
            ],
          ],
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
      case 1:
        return '高';
      case 2:
        return '中';
      case 3:
        return '低';
      default:
        return '未知';
    }
  }

  void _confirmDeleteGoal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("确认删除目标？"),
        content: const Text("删除后无法恢复。"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("取消")),
          ElevatedButton(
            onPressed: () async {
              await ref.read(goalListProvider.notifier).deleteGoal(goal.id);
              Navigator.pop(context);
            },
            child: const Text("删除"),
          ),
        ],
      ),
    );
  }

  void _removeSubGoal(WidgetRef ref, SubGoal sub) async {
    final updated = goal.copyWith(
      subGoals: goal.subGoals.where((s) => s.id != sub.id).toList(),
    );
    await ref.read(goalListProvider.notifier).updateGoal(updated);
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
          dailyTotals.update(dayOffset, (v) => v + log.minutesSpent, ifAbsent: () => log.minutesSpent);
        }
      }
    }

    int remaining = goal.subGoals.fold(0, (sum, sub) => sum + sub.estimatedMinutes);
    final actualData = <FlSpot>[];
    final idealData = <FlSpot>[];

    for (int day = 0; day <= totalDays; day++) {
      if (day > 0) {
        remaining -= (dailyTotals[day - 1] ?? 0);
      }
      actualData.add(FlSpot(day.toDouble(), remaining.toDouble()));
      final idealRemaining = goal.subGoals.fold(0, (sum, sub) => sum + sub.estimatedMinutes) * (1 - day / totalDays);
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

