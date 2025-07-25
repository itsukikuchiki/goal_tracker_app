import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/goal_provider.dart';
import '../../screen/goal/goal_edit_screen.dart';
import '../../model/goal.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  void _navigateToAddGoal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoalEditScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalList = ref.watch(goalListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("我的目标"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddGoal(context),
        child: const Icon(Icons.add),
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(goal.title, style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("截止：${goal.endDate.toLocal().toString().split(' ')[0]}"),
            Text("优先级：${goal.priority}"),
            Text("子目标数：${goal.subGoals.length}"),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // 可扩展：进入详情页或编辑
        },
      ),
    );
  }
}

