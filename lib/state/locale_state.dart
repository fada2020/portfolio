// 언어 설정 상태 관리를 위한 패키지들
import 'package:flutter/material.dart';                        // Locale 클래스 사용
import 'package:flutter_riverpod/flutter_riverpod.dart';       // Provider 시스템
import 'package:portfolio/services/locale_store.dart' as store; // 로컬 스토리지 서비스

/// 현재 세션에서 선택된 언어 상태를 관리하는 Provider
/// StateProvider: 간단한 상태값을 저장하고 변경할 수 있음
/// 초기값은 null이며, 사용자가 언어를 선택하면 Locale 객체가 저장됨
final selectedLocaleProvider = StateProvider<Locale?>((ref) => null);

/// 로컬 스토리지에 저장된 언어 설정을 가져오는 Provider
/// FutureProvider: 비동기 작업(로컬 스토리지 읽기)의 결과를 캐시
/// 앱 시작 시 한 번만 실행되어 이전에 저장된 언어 설정을 복원함
final savedLocaleProvider = FutureProvider<Locale?>((ref) async {
  // 로컬 스토리지에서 저장된 언어 코드를 가져옴
  final code = await store.getSavedLocaleCode();

  // 저장된 언어 코드가 없는 경우 null 반환 (시스템 기본 언어 사용)
  if (code == null || code.isEmpty) return null;

  // 언어 코드 파싱: 'en-US' 형식을 지원하지만 현재는 'en', 'ko'만 사용
  final parts = code.split('-');
  return Locale(parts.first);  // 첫 번째 부분(언어 코드)만 사용
});

/// 언어 설정을 변경하는 헬퍼 함수
/// 1. 현재 세션 상태 업데이트 (selectedLocaleProvider)
/// 2. 로컬 스토리지에 영구 저장 (다음 앱 실행 시까지 유지)
Future<void> setLocale(WidgetRef ref, Locale? locale) async {
  // 현재 세션의 선택된 언어 상태 업데이트
  ref.read(selectedLocaleProvider.notifier).state = locale;

  // 로컬 스토리지에 언어 코드 저장 (브라우저의 localStorage 또는 앱의 SharedPreferences)
  await store.saveLocaleCode(locale?.languageCode);
}

