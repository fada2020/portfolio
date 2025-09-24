// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<String?> getSavedThemeModeCode() async {
  return html.window.localStorage['theme_mode'];
}

Future<void> saveThemeModeCode(String? code) async {
  if (code == null) {
    html.window.localStorage.remove('theme_mode');
  } else {
    html.window.localStorage['theme_mode'] = code;
  }
}
