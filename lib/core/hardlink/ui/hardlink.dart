import 'package:alt/core/hardlink/providers/filesystem_provider.dart';
import 'package:alt/core/hardlink/ui/folder_view.dart';
import 'package:alt/core/hardlink/ui/hardlink_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HardlinkPage extends ConsumerWidget {
  const HardlinkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: FolderView(
                  input: FolderInput(initialDir: '/mnt/pool/media/', tab: 0),
                ),
              ),
              Expanded(
                child: FolderView(
                  input: FolderInput(initialDir: '/mnt/pool/media/', tab: 1),
                ),
              ),
            ],
          ),
        ),
        HardlinkBar(),
      ],
    );
  }
}
