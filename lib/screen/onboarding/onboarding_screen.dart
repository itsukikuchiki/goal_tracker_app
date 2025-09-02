import 'package:flutter/material.dart';
import 'package:goal_tracker_app/screen/goal/goal_screen.dart';
import 'package:goal_tracker_app/widget/onboarding/onboarding_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingStep> _steps = const [
    OnboardingStep(
      icon: Icons.flag,
      title: '设定目标',
      description: '创建清晰的目标，拆解为可执行的子目标。',
    ),
    OnboardingStep(
      icon: Icons.today,
      title: '每日打卡',
      description: '记录每日投入，养成持续行动的习惯。',
    ),
    OnboardingStep(
      icon: Icons.bar_chart,
      title: '时间统计',
      description: '了解每周投入，优化你的时间分配。',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 完成引导后跳转主页面
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GoalScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _currentIndex == _steps.length - 1;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _steps.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) => _steps[index],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _steps.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 12 : 8,
                      height: _currentIndex == index ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? theme.colorScheme.primary
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(isLast ? '开始使用' : '下一步'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

