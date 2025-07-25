import 'package:flutter/material.dart';

class ScheduleAddScreen extends StatelessWidget {
  const ScheduleAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日程を追加'),
      ),
      body: const Center(
        child: Text('ここに日程追加画面のUIを実装'),
      ),
    );
  }
}

