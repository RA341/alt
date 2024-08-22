import 'package:alt/core/hardlink/providers/provider.filesystem.dart';
import 'package:alt/core/hardlink/providers/provider.hardlink.dart';
import 'package:alt/core/hardlink/ui/dialog.create_folder.dart';
import 'package:alt/core/hardlink/ui/tile.currentdir.dart';
import 'package:alt/core/hardlink/ui/tile.file.dart';
import 'package:alt/core/hardlink/ui/tile.folder.dart';
import 'package:alt/core/hardlink/ui/tile.previous_dir.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:alt/protos/filesystem.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class FolderView extends ConsumerStatefulWidget {
  const FolderView({
    required this.input,
    super.key,
  });

  final FolderInput input;

  @override
  ConsumerState createState() => _FolderViewState();
}

class _FolderViewState extends ConsumerState<FolderView> {
  FolderInput get input => widget.input;

  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(
      () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final folder = ref.watch(folderProvider(input));

    return folder.when(
      data: (returnedData) {
        final data = returnedData;

        final folderList = data.folders;
        final fileList = data.files;

        final listItemCount = folderList.length + fileList.length + 2;
        return Column(
          children: [
            AppBar(
              actions: [
                SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SearchBar(
                      controller: searchController,
                      hintText: 'Search folder',
                      onChanged: (value) {
                        searchController.text = value;
                      },
                      trailing: [
                        IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: NewFolderDialog(parentPath: data.fullPath),
                        );
                      },
                    );
                    refreshDir(data);
                  },
                  icon: const Icon(Icons.create_new_folder),
                ),
                IconButton(
                  onPressed: () async {
                    refreshDir(data);
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(data.fullPath),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listItemCount,
                itemBuilder: (context, index) {
                  // accounting for current directory tile
                  final realIndex = index - 2;
                  if (index == 0) {
                    return CurrentDirTile(currentDirPath: data.fullPath);
                  } else if (index == 1) {
                    return PreviousFolderTile(
                      folder: Folder(fullPath: path.dirname(data.fullPath)),
                      tabIndex: input,
                      clearSearch: searchController.clear,
                    );
                  }

                  if (folderList.length > realIndex) {
                    return BuildFolderWidget(
                      searchController: searchController,
                      folder: folderList[realIndex],
                      input: input,
                    );
                  }

                  final fileIndex = realIndex - folderList.length;
                  return BuildFileTile(
                    query: searchController.text,
                    file: fileList[fileIndex],
                    data: data,
                  );
                },
              ),
            ),
          ],
        ).animate().fadeIn(duration: const Duration(milliseconds: 225));
      },
      error: (error, stackTrace) {
        return Center(
          child: Column(
            children: [
              Text(error.toString()),
              IconButton(
                onPressed: () {
                  ref.read(folderProvider(input).notifier).refreshDir(
                        input.initialDir,
                      );
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator())
          .animate()
          .fadeIn(duration: const Duration(seconds: 1)),
    );
  }

  void refreshDir(Folder data) {
    ref.read(folderProvider(input).notifier).refreshDir(data.fullPath);
  }
}

class BuildFolderWidget extends StatelessWidget {
  const BuildFolderWidget({
    required this.searchController,
    required this.folder,
    required this.input,
    super.key,
  });

  final TextEditingController searchController;
  final Folder folder;
  final FolderInput input;

  @override
  Widget build(BuildContext context) {
    final query = searchController.text;

    if (query.isEmpty) {
      return FolderTile(
        folder: folder,
        tabIndex: input,
        clearSearch: searchController.clear,
      );
    }

    if (path
        .basename(folder.fullPath)
        .toLowerCase()
        .contains(query.toLowerCase())) {
      return FolderTile(
        folder: folder,
        tabIndex: input,
        clearSearch: searchController.clear,
      );
    }

    return const SizedBox();
  }
}

class BuildFileTile extends StatelessWidget {
  const BuildFileTile({
    required this.query,
    required this.file,
    required this.data,
    super.key,
  });

  final String query;
  final File file;
  final Folder data;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return FileTile(file: file, parentPath: data.fullPath);
    }

    if (path.basename(file.name).toLowerCase().contains(query.toLowerCase())) {
      return FileTile(file: file, parentPath: data.fullPath);
    }

    return const SizedBox();
  }
}

class HardlinkButtons extends ConsumerWidget {
  const HardlinkButtons({
    required this.fPath,
    super.key,
    this.isFile = false,
    this.parentPath = '',
  });

  final bool isFile;
  final String fPath;
  final String? parentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final src = ref.watch(srcPathProvider);
    final isSrcSelected = src == fPath;

    final dest = ref.watch(destPathProvider);
    final isDestSelected = dest == fPath;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: isDestSelected
              ? null
              : () {
                  if (isSrcSelected) {
                    ref.read(srcPathProvider.notifier).state = '';
                    return;
                  }
                  ref.read(srcPathProvider.notifier).state = fPath;
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSrcSelected
                ? Theme.of(context).highlightColor.withGreen(30)
                : null,
          ),
          child: const Text('Hardlink Source'),
        ),
        const SizedBox(width: 10),
        if (!isFile) // a file should not be hardlink destination
          ElevatedButton(
            onPressed: isSrcSelected
                ? null
                : () {
                    if (isDestSelected) {
                      ref.read(destPathProvider.notifier).state = '';
                      return;
                    }

                    final autoFillDestination =
                        ref.read(autofillDestinationProvider);

                    if (autoFillDestination &&
                        parentPath != null &&
                        fPath == parentPath) {
                      // autofill with src dir name
                      ref.read(destPathProvider.notifier).state =
                          '$fPath/${path.basename(src)}';
                      return;
                    }
                    ref.read(destPathProvider.notifier).state = fPath;
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestSelected
                  ? Theme.of(context).primaryColorDark.withGreen(50)
                  : null,
            ),
            child: const Text('Hardlink Destination'),
          ),
      ],
    );
  }
}
