import 'package:alt/core/hardlink/ui/widget.folder_view.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileTile extends ConsumerWidget {
  const FileTile({
    required this.parentPath,
    required this.file,
    super.key,
  });

  final String parentPath;
  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.file_present),
      title: Text(file.name),
      trailing: HardlinkButtons(
        fPath: '$parentPath/${file.name}',
        isFile: true,
      ),
    );
  }
}
