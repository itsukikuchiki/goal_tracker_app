import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../model/goal.dart';
import '../../model/sub_goal.dart';
import '../../provider/goal_provider.dart';
import '../../widget/subgoal_editor.dart';

class GoalEditScreen extends ConsumerStatefulWidget {
  final Goal? goal; // 为空表示新增

  const GoalEditScreen({super.key, this.goal});

  @override
  ConsumerState<GoalEditScreen> createState() => _GoalEditScreenState();
}

class _GoalEditScreenState extends ConsumerState<GoalEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _startDate;
  late DateTime _endDate;
  int _priority = 2;
  List<SubGoal> _subGoals = [];

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _title = g?.title ?? '';
    _description = g?.description ?? '';
    _startDate = g?.startDate ?? DateTime.now();
    _endDate = g?.endDate ?? DateTime.now().add(const Duration(days: 30));
    _priority = g?.priority ?? 2;
    _subGoals = List.from(g?.subGoals ?? []);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newGoal = Goal(
        id: widget.goal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        startDate: _startDate,
        endDate: _endDate,
        priority: _priority,
        subGoals: _subGoals,
      );

     final notifier = ref.read(goalListProvider.notifier);
     if (widget.goal == null) {
        await notifier.addGoal(newGoal);
      } else {
        await notifier.updateGoal(newGoal);
      }

     await notifier.loadGoals(); // ✅ 添加此行，强制重新读取 Hive 中的所有数据

     if (mounted) Navigator.of(context).pop();
  }
}

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? '新增目标' : '编辑目标'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: '标题'),
                validator: (v) => v!.isEmpty ? '请输入标题' : null,
                onSaved: (v) => _title = v!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: '描述'),
                onSaved: (v) => _description = v ?? '',
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text('${formatter.format(_startDate)} - ${formatter.format(_endDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateRange,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('高优先级')),
                  DropdownMenuItem(value: 2, child: Text('中优先级')),
                  DropdownMenuItem(value: 3, child: Text('低优先级')),
                ],
                decoration: const InputDecoration(labelText: '优先级'),
                onChanged: (v) => setState(() => _priority = v ?? 2),
              ),
              const Divider(height: 32),
              const Text('子目标', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._subGoals.map((sub) => ListTile(
                    title: Text(sub.title),
                    subtitle: Text('截止：${formatter.format(sub.dueDate)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => _subGoals.remove(sub));
                      },
                    ),
                  )),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('添加子目标'),
                onPressed: () async {
                  final newSub = await showDialog<SubGoal>(
                    context: context,
                    builder: (_) => SubGoalEditor(goalId: widget.goal?.id ?? 'temp'),
                  );
                  if (newSub != null) {
                    setState(() => _subGoals.add(newSub));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

