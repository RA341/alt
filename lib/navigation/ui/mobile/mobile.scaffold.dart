import 'package:alt/navigation/navigation_provider.dart';
import 'package:alt/navigation/page_list.dart';
import 'package:alt/navigation/ui/mobile/mobile_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileBaseScaffold extends ConsumerWidget {
  const MobileBaseScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationProvider);

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: const MobileNavBar(),
    );
  }
}
