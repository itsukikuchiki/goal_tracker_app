import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/goal.dart';
import '../../model/sub_goal.dart';
import '../../provider/goal_provider.dart';

class GoalEditScreen extends ConsumerStatefulWidget {
  const GoalEditScreen({super.key});

  @override
  ConsumerState<GoalEditScreen> createState() => _GoalEditScreenState();
}

class _GoalEditScreenState extends ConsumerState<GoalEditScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  int priority = 2;

  final List<SubGoal> subGoals = [];

  void _addSubGoal() {
    setState(() {
      subGoals.add(SubGoal.empty(goalId: 'temp'));
    });
  }

  void _saveGoal() {
    final goal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      description: descController.text.trim(),
      startDate: startDate,
      endDate: endDate,
      priority: priority,
      subGoals: subGoals,
    );

    ref.read(goalListProvider.notifier).addGoal(goal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("创建新目标"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "主目标标题",
                border: OutlineInputBorder(),
              ),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "目标描述",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text("开始日期"),
                    subtitle: Text("${startDate.toLocal()}".split(' ')[0]),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text("结束日期"),
                    subtitle: Text("${endDate.toLocal()}".split(' ')[0]),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("优先级", style: theme.textTheme.titleMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3].map((p) {
                return ChoiceChip(
                  label: Text("优先级 $p"),
                  selected: priority == p,
                  onSelected: (_) => setState(() => priority = p),
                );
              }).toList(),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("子目标", style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSubGoal,
                )
              ],
            ),
            ...subGoals.asMap().entries.map((entry) {
              final index = entry.key;
              final sub = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "子目标 ${index + 1}",
                    ),
                    onChanged: (val) {
                      subGoals[index] = SubGoal(
                        id: sub.id,
                        goalId: sub.goalId,
                        title: val,
                        dueDate: sub.dueDate,
                        estimatedMinutes: sub.estimatedMinutes,
                        isCompleted: false,
                        logs: [],
                      );
                    },
                  ),
                ),
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: _saveGoal,
          child: const Text("保存目标"),
        ),
      ),
    );
  }
}

