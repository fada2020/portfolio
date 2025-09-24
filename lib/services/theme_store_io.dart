String? _saved;

Future<String?> getSavedThemeModeCode() async {
  return _saved;
}

Future<void> saveThemeModeCode(String? code) async {
  _saved = code;
}
