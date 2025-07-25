// lib/screen/calendar/calendar_screen.dart
import 'package:flutter/material.dart';
import 'calendar_month.dart';
import 'calendar_week.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    CalendarMonthScreen(),
    CalendarWeekScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '月',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: '週',
          ),
        ],
      ),
    );
  }
}
