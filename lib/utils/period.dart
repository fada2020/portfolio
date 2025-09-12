int periodStartKey(String period) {
  // Expected like '2023.01–2023.09' or '2023.01-2023.09'
  final normalized = period.replaceAll('–', '-');
  final parts = normalized.split('-');
  final start = parts.isNotEmpty ? parts.first.trim() : period.trim();
  final ym = start.split('.');
  if (ym.length >= 2) {
    final y = int.tryParse(ym[0]) ?? 0;
    final m = int.tryParse(ym[1]) ?? 0;
    return y * 100 + m;
  }
  return 0;
}

