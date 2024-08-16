import 'package:alt/core/navigation/desktop/desktop.scaffold.dart';
import 'package:alt/core/navigation/mobile/mobile.scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScaffholdSelector extends ConsumerWidget {
  const ScaffholdSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return const DesktopBaseScaffold();
        } else {
          return const MobileBaseScaffold();
        }
      },
    );
  }
}
