import 'package:flutter/material.dart';
import '../../model/sub_goal.dart';
import '../../model/daily_log.dart';

class LogEntryDialog extends StatefulWidget {
  final String goalId;
  final SubGoal subGoal;

  const LogEntryDialog({super.key, required this.goalId, required this.subGoal});

  @override
  State<LogEntryDialog> createState() => _LogEntryDialogState();
}

class _LogEntryDialogState extends State<LogEntryDialog> {
  final _timeController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('「${widget.subGoal.title}」に打刻'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _timeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: '実績時間（分）'),
          ),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: 'メモ（任意）'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('保存'),
          onPressed: () {
            final time = int.tryParse(_timeController.text) ?? 0;
            final log = DailyLog(
              date: DateTime.now(),
              actualMinutes: time,
              note: _noteController.text,
            );
            Navigator.pop(context, log);
          },
        ),
      ],
    );
  }
}

