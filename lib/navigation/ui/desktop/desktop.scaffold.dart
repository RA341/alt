import 'package:alt/navigation/provider.navigation.dart';
import 'package:alt/navigation/ui/desktop/desktop_nav_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesktopBaseScaffold extends ConsumerWidget {
  const DesktopBaseScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationProvider);

    return Scaffold(
      body: Row(
        children: [
          const DesktopNavRail(),
          Expanded(child: pages[index]),
        ],
      ),
      // bottomNavigationBar: index == 1 ? const HardlinkBar() : const SizedBox(),
    );
  }
}
