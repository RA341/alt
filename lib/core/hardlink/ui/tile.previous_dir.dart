import 'package:alt/core/hardlink/providers/provider.filesystem.dart';
import 'package:alt/core/hardlink/ui/widget.folder_view.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviousFolderTile extends ConsumerWidget {
  const PreviousFolderTile({
    required this.folder,
    required this.tabIndex,
    required this.clearSearch,
    super.key,
  });

  final Folder folder;
  final FolderInput tabIndex;
  final void Function() clearSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.arrow_back_outlined),
      title: const Text('..', style: TextStyle(fontSize: 22)),
      onTap: () async {
        await ref
            .read(folderProvider(tabIndex).notifier)
            .changeDir(folder.fullPath);
        clearSearch();
      },
      trailing: HardlinkButtons(fPath: folder.fullPath),
    );
  }
}