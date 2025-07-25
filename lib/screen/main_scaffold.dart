import 'package:flutter/material.dart';
import 'package:goal_tracker_app/screen/calendar/calendar_screen.dart';
import 'package:goal_tracker_app/screen/goal/goal_list_screen.dart';
import 'package:goal_tracker_app/screen/settings/settings_screen.dart';
import 'package:goal_tracker_app/screen/stats/stats_screen.dart';
import 'package:goal_tracker_app/screen/goal/goal_edit_screen.dart';
import 'package:goal_tracker_app/screen/calendar/schedule_add_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CalendarScreen(),
    const GoalListScreen(),
    const Placeholder(), // 中间 + 按钮不切换页面
    const StatsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _onPlusPressed();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onPlusPressed() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('目標を追加'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GoalEditScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('日程を追加'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScheduleAddScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex > 2 ? _selectedIndex : (_selectedIndex == 2 ? 0 : _selectedIndex),
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'カレンダー'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '目標'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: '集計'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }
}

