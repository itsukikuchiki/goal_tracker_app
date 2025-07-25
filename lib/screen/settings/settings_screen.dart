import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/theme_provider.dart';
import '../../provider/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("设置")),
      body: ListView(
        children: [
          const ListTile(
            title: Text("显示设置", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("浅色主题"),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) => ref.read(themeProvider.notifier).setTheme(value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text("深色主题"),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) => ref.read(themeProvider.notifier).setTheme(value!),
          ),
          const Divider(),
          const ListTile(
            title: Text("语言选择", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          RadioListTile<Locale>(
            title: const Text("简体中文"),
            value: const Locale('zh'),
            groupValue: locale,
            onChanged: (value) => ref.read(localeProvider.notifier).setLocale(value!),
          ),
          RadioListTile<Locale>(
            title: const Text("日本語"),
            value: const Locale('ja'),
            groupValue: locale,
            onChanged: (value) => ref.read(localeProvider.notifier).setLocale(value!),
          ),
          RadioListTile<Locale>(
            title: const Text("English"),
            value: const Locale('en'),
            groupValue: locale,
            onChanged: (value) => ref.read(localeProvider.notifier).setLocale(value!),
          ),
          const Divider(),
          const ListTile(
            title: Text("其他功能", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text("导出数据（未实现）"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("导出功能尚未实现")),
              );
            },
          ),
        ],
      ),
    );
  }
}

