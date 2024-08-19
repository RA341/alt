import 'package:alt/core/hardlink/ui/page.hardlink.dart';
import 'package:alt/core/settings/ui/page.settings.dart';
import 'package:alt/core/system/ui/page.system_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateProvider<int>((ref) {
  return 1;
});

final pages = <Widget>[
  const SystemControls(),
  const HardlinkPage(),
  const SettingsPage(),
];
