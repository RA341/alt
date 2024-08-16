import 'package:alt/core/hardlink/ui/hardlink.dart';
import 'package:alt/core/hardlink/ui/hardlink_bar.dart';
import 'package:alt/core/settings/ui/settings_page.dart';
import 'package:alt/core/system/ui/system_controls.dart';
import 'package:alt/main.dart';
import 'package:flutter/material.dart';

final pages = <Widget>[
  const SystemControls(),
  const HardlinkPage(),
  const SettingsPage(),
];
