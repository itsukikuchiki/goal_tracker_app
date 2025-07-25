import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../provider/goal_provider.dart';
import '../../model/daily_log.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalListProvider);

    // 计算本周每天的总投入时间（分钟）
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    Map<String, int> weeklyData = {
      for (var day in days) _formatDay(day): 0,
    };

    for (final goal in goals) {
      for (final sub in goal.subGoals) {
        for (final log in sub.logs) {
          if (_isSameWeek(log.date, monday)) {
            final label = _formatDay(log.date);
            weeklyData[label] = (weeklyData[label] ?? 0) + log.minutesSpent;
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("每周时间统计")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: weeklyData.entries.mapIndexed((i, e) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: e.value.toDouble(),
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blueAccent,
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= weeklyData.length) return const SizedBox();
                    return Text(weeklyData.keys.elementAt(index));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, _) => Text(value.toInt().toString()),
                ),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  String _formatDay(DateTime date) {
    const weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];
    return weekdayLabels[date.weekday - 1];
  }

  bool _isSameWeek(DateTime logDate, DateTime mondayOfThisWeek) {
    final weekStart = mondayOfThisWeek;
    final weekEnd = weekStart.add(const Duration(days: 7));
    return logDate.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
        logDate.isBefore(weekEnd);
  }
}

extension<E> on Iterable<E> {
  List<T> mapIndexed<T>(T Function(int index, E e) f) {
    var i = 0;
    return map((e) => f(i++, e)).toList();
  }
}

