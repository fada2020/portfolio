import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/profile.dart';
import 'package:portfolio/services/content_loader.dart';

final profileProvider = FutureProvider.family<Profile, String>((ref, localeCode) async {
  return loadProfile(localeCode);
});

