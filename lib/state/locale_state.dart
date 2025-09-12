import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/services/locale_store.dart' as store;

final selectedLocaleProvider = StateProvider<Locale?>((ref) => null);

final savedLocaleProvider = FutureProvider<Locale?>((ref) async {
  final code = await store.getSavedLocaleCode();
  if (code == null || code.isEmpty) return null;
  // Support language-only codes like 'en' or 'ko'
  final parts = code.split('-');
  return Locale(parts.first);
});

Future<void> setLocale(WidgetRef ref, Locale? locale) async {
  ref.read(selectedLocaleProvider.notifier).state = locale;
  await store.saveLocaleCode(locale?.languageCode);
}

