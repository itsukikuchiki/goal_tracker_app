import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/task.dart';
import '../../provider/task_provider.dart';

class ScheduleEditScreen extends ConsumerStatefulWidget {
  const ScheduleEditScreen({super.key});

  @override
  ConsumerState<ScheduleEditScreen> createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends ConsumerState<ScheduleEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _selectedDate = DateTime.now();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        scheduledDate: _selectedDate, // ✅ 正确字段名
      );

      await ref.read(taskListProvider.notifier).addTask(newTask);

      if (mounted) Navigator.of(context).pop(); // 保存后关闭页面
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日程を追加'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'タイトル'),
                validator: (v) => v == null || v.isEmpty ? 'タイトルを入力してください' : null,
                onSaved: (v) => _title = v!,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('日付: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

