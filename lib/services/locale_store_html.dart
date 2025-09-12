// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

Future<String?> getSavedLocaleCode() async {
  return html.window.localStorage['locale'];
}

Future<void> saveLocaleCode(String? code) async {
  if (code == null) {
    html.window.localStorage.remove('locale');
  } else {
    html.window.localStorage['locale'] = code;
  }
}
