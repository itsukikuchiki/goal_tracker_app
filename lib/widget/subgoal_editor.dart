import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/sub_goal.dart';

class SubGoalEditor extends StatefulWidget {
  final String goalId;

  const SubGoalEditor({super.key, required this.goalId});

  @override
  State<SubGoalEditor> createState() => _SubGoalEditorState();
}

class _SubGoalEditorState extends State<SubGoalEditor> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  int _estimatedMinutes = 30;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final subGoal = SubGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        goalId: widget.goalId,
        title: _title,
        dueDate: _dueDate,
        estimatedMinutes: _estimatedMinutes,
        isCompleted: false,
        logs: [],
      );

      Navigator.of(context).pop(subGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd();
    return AlertDialog(
      title: const Text('新增子目标'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '子目标标题'),
              validator: (v) => v == null || v.trim().isEmpty ? '请输入标题' : null,
              onSaved: (v) => _title = v!.trim(),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text('截止日期：${formatter.format(_dueDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _estimatedMinutes,
              decoration: const InputDecoration(labelText: '预估时间（分钟）'),
              items: const [
                DropdownMenuItem(value: 15, child: Text('15分钟')),
                DropdownMenuItem(value: 30, child: Text('30分钟')),
                DropdownMenuItem(value: 45, child: Text('45分钟')),
                DropdownMenuItem(value: 60, child: Text('1小时')),
                DropdownMenuItem(value: 90, child: Text('1.5小时')),
                DropdownMenuItem(value: 120, child: Text('2小时')),
              ],
              onChanged: (v) => setState(() => _estimatedMinutes = v ?? 30),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        ElevatedButton(onPressed: _save, child: const Text('保存')),
      ],
    );
  }
}

