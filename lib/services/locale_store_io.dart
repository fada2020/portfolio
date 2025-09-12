String? _memoryCode;

Future<String?> getSavedLocaleCode() async {
  return _memoryCode;
}

Future<void> saveLocaleCode(String? code) async {
  _memoryCode = code;
}

