import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/sub_goal.dart';
import '../provider/goal_provider.dart';

class SubGoalList extends ConsumerWidget {
  final String goalId;

  const SubGoalList({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(goalListProvider).firstWhere((g) => g.id == goalId);
    final subGoals = goal.subGoals;

    if (subGoals.isEmpty) {
      return const Text("尚未添加子目标");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subGoals.map((sub) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () {
              ref.read(goalListProvider.notifier).toggleSubGoalCompleted(goalId, sub.id);
            },
            child: Row(
              children: [
                Icon(
                  sub.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: sub.isCompleted ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sub.title,
                    style: TextStyle(
                      decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                      color: sub.isCompleted ? Colors.grey : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
