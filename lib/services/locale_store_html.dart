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

