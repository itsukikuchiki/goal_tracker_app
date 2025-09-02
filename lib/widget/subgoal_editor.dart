import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/sub_goal.dart';

class SubGoalEditor extends StatefulWidget {
  final String goalId;
  final SubGoal? subGoal;

  const SubGoalEditor({
    super.key,
    required this.goalId,
    this.subGoal,
  });

  @override
  State<SubGoalEditor> createState() => _SubGoalEditorState();
}

class _SubGoalEditorState extends State<SubGoalEditor> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.subGoal != null) {
      _title = widget.subGoal!.title;
      _startTime = widget.subGoal!.startTime;
      _endTime = widget.subGoal!.endTime;
    }
  }

  Future<void> _pickDate({
    required bool isStart,
  }) async {
    final now = DateTime.now();
    final initialDate = isStart ? _startTime : _endTime;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null || _startTime!.isAfter(_endTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請選擇有效的日期範圍')),
      );
      return;
    }

    final subGoal = widget.subGoal?.copyWith(
          title: _title,
          startTime: _startTime!,
          endTime: _endTime!,
          isCompleted: widget.subGoal?.isCompleted ?? false,
        ) ??
        SubGoal(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          goalId: widget.goalId,
          title: _title,
          startTime: _startTime!,
          endTime: _endTime!,
          isCompleted: false,
          logs: const [],
        );

    Navigator.of(context).pop(subGoal);
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');

    return AlertDialog(
      title: Text(widget.subGoal == null ? '新增子目标' : '编辑子目标'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: '标题'),
              validator: (v) => v == null || v.isEmpty ? '请输入标题' : null,
              onChanged: (v) => _title = v,
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(_startTime == null
                  ? '选择开始日期'
                  : df.format(_startTime!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isStart: true),
            ),
            ListTile(
              title: Text(_endTime == null
                  ? '选择结束日期'
                  : df.format(_endTime!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isStart: false),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('确定'),
        ),
      ],
    );
  }
}

