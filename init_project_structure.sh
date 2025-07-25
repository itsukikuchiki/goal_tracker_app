#!/bin/bash

echo "🚀 正在创建 Flutter 初始目录结构..."

mkdir -p lib/config
mkdir -p lib/model
mkdir -p lib/service
mkdir -p lib/provider
mkdir -p lib/screen/onboarding
mkdir -p lib/screen/goal
mkdir -p lib/screen/calendar
mkdir -p lib/screen/stats
mkdir -p lib/screen/settings
mkdir -p lib/widget
mkdir -p lib/l10n

touch lib/config/app_theme.dart
touch lib/config/app_locale.dart
touch lib/config/constants.dart

touch lib/model/goal.dart
touch lib/model/sub_goal.dart
touch lib/model/daily_log.dart

touch lib/service/storage_service.dart
touch lib/service/goal_repository.dart

touch lib/provider/goal_provider.dart
touch lib/provider/log_provider.dart
touch lib/provider/theme_provider.dart

touch lib/screen/onboarding/onboarding_screen.dart
touch lib/screen/goal/goal_list_screen.dart
touch lib/screen/goal/goal_edit_screen.dart
touch lib/screen/calendar/calendar_screen.dart
touch lib/screen/stats/stats_screen.dart
touch lib/screen/settings/settings_screen.dart

touch lib/widget/goal_card.dart
touch lib/widget/subgoal_editor.dart
touch lib/widget/calendar_tile.dart
touch lib/widget/chart_radar.dart

touch lib/l10n/en.arb
touch lib/l10n/ja.arb
touch lib/l10n/zh.arb

echo "✅ 项目结构创建完毕！"



