import 'package:alt/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileNavBar extends ConsumerWidget {
  const MobileNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.2,
      width: double.infinity,
      child: NavigationBar(
        onDestinationSelected: (value) =>
            ref.read(navigationProvider.notifier).state = value,
        selectedIndex: index,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.link),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
