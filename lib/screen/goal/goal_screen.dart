import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../provider/goal_provider.dart';
import '../../screen/goal/goal_edit_screen.dart';
import '../../model/goal.dart';
import '../../model/daily_log.dart';
import '../../widget/progress_ring.dart';
import '../../widget/sub_goal_list.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  void _navigateToAddGoal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoalEditScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalList = [...ref.watch(goalListProvider)];
    goalList.sort((a, b) => b.priority.compareTo(a.priority));

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎯 我的目標"),
      ),
      body: goalList.isEmpty
          ? const Center(child: Text("暂无目标，点击 + 创建一个吧！"))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: goalList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final goal = goalList[index];
                return GoalCard(goal: goal);
              },
            ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GoalEditScreen(goal: goal), // ✅ 传入当前 Goal
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
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
                    child: Text(
                      goal.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            ],
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

