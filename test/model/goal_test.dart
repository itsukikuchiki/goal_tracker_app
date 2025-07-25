import 'package:flutter_test/flutter_test.dart';
import 'package:goal_tracker_app/model/goal.dart';
import 'package:goal_tracker_app/model/sub_goal.dart';
import 'package:goal_tracker_app/model/daily_log.dart';

void main() {
  group("Goal model", () {
    test("should construct with nested SubGoals and DailyLogs", () {
      final log = DailyLog(date: DateTime(2025, 7, 24), minutesSpent: 30, note: "测试备注");
      final subGoal = SubGoal(
        id: "sub1",
        goalId: "goal1",
        title: "子任务1",
        dueDate: DateTime(2025, 7, 30),
        estimatedMinutes: 60,
        isCompleted: false,
        logs: [log],
      );
      final goal = Goal(
        id: "goal1",
        title: "测试目标",
        description: "测试描述",
        startDate: DateTime(2025, 7, 20),
        endDate: DateTime(2025, 8, 20),
        priority: 2,
        subGoals: [subGoal],
      );

      expect(goal.title, "测试目标");
      expect(goal.subGoals.length, 1);
      expect(goal.subGoals.first.logs.first.minutesSpent, 30);
    });
  });
}

