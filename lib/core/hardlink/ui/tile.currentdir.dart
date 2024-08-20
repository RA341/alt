import 'package:alt/core/hardlink/ui/widget.folder_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentDirTile extends ConsumerWidget {
  const CurrentDirTile({
    required this.currentDirPath,
    super.key,
  });

  final String currentDirPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.folder_outlined),
      title: const Text('.', style: TextStyle(fontSize: 22)),
      trailing: HardlinkButtons(
        fPath: currentDirPath,
        parentPath: currentDirPath,
      ),
    );
  }
}
