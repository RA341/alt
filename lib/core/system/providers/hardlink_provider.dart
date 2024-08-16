import 'package:flutter_riverpod/flutter_riverpod.dart';

final srcPathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final destPathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});
