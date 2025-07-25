import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/goal.dart';
import '../../widget/subgoal_editor.dart';
import '../../provider/goal_provider.dart';
import '../log/log_entry_dialog.dart';

class GoalDetailScreen extends ConsumerWidget {
  final Goal goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(goal.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              '期間：${goal.startDate.toLocal().toString().split(" ")[0]} ～ ${goal.endDate.toLocal().toString().split(" ")[0]}',
            ),
            const SizedBox(height: 8),
            Text('優先度：${goal.priority}'),
            const Divider(height: 32),

            Text('子目標', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: goal.subGoals.length,
                itemBuilder: (context, index) {
                  final sub = goal.subGoals[index];
                  return ListTile(
                    title: Text(sub.title),
                    subtitle: Text('予定 ${sub.estimatedMinutes}分'),
                    trailing: Icon(
                      sub.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: sub.isCompleted ? Colors.green : null,
                    ),
                    onTap: () async {
                      final updated = await showDialog(
                        context: context,
                        builder: (_) => LogEntryDialog(goalId: goal.id, subGoal: sub),
                      );
                      if (updated != null) {
                        ref.read(goalListProvider.notifier).updateLog(goal.id, sub.id, updated);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

