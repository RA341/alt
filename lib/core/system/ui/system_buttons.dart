import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemButtons extends ConsumerWidget {
  const SystemButtons({super.key});

  static const systemButtonPadding = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(systemButtonPadding),
            child:
                ElevatedButton(onPressed: () {}, child: const Text('Shutdown')),
          ),
          Padding(
            padding: const EdgeInsets.all(systemButtonPadding),
            child: ElevatedButton(onPressed: () {}, child: const Text('Sleep')),
          ),
          Padding(
            padding: const EdgeInsets.all(systemButtonPadding),
            child:
                ElevatedButton(onPressed: () {}, child: const Text('Reboot')),
          ),
        ],
      ),
    );
  }
}
