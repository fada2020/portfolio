import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/services/theme_store.dart' as store;

String? _modeToCode(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => 'system',
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
  };
}

ThemeMode? _codeToMode(String? code) {
  return switch (code) {
    'system' => ThemeMode.system,
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => null,
  };
}

final selectedThemeModeProvider = StateProvider<ThemeMode?>((ref) => null);

final savedThemeModeProvider = FutureProvider<ThemeMode?>((ref) async {
  final code = await store.getSavedThemeModeCode();
  return _codeToMode(code);
});

Future<void> setThemeMode(WidgetRef ref, ThemeMode mode) async {
  ref.read(selectedThemeModeProvider.notifier).state = mode;
  await store.saveThemeModeCode(_modeToCode(mode));
}
