import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/daily_log.dart';
import 'model/sub_goal.dart';
import 'model/goal.dart';

import 'screen/onboarding/onboarding_screen.dart';
import 'screen/splash/splash_screen.dart';

import 'config/app_theme.dart';

import 'provider/theme_provider.dart';
import 'provider/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // 注册 Hive Adapter
  Hive.registerAdapter(DailyLogAdapter());
  Hive.registerAdapter(SubGoalAdapter());
  Hive.registerAdapter(GoalAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '目標手帳',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ref.watch(themeProvider),
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const SplashScreen(), // ✅ 更新为 Splash
    );
  }
}
