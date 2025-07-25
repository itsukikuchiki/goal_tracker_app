import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/daily_log.dart';
import 'model/sub_goal.dart';
import 'model/goal.dart';

import 'screen/onboarding/onboarding_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'screen/main_scaffold.dart';

import 'config/app_theme.dart';
import 'config/app_locale.dart';

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Widget _nextScreen = const SplashScreen();

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 2)); // 等待 2 秒 Splash

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      setState(() => _nextScreen = const OnboardingScreen());
    } else {
      setState(() => _nextScreen = const MainScaffold());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '目標手帳',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _nextScreen,
    );
  }
}

