import 'package:alt/core/hardlink/providers/filesystem_provider.dart';
import 'package:alt/core/hardlink/providers/hardlink_provider.dart';
import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:alt/protos/filesystem.pbgrpc.dart';
import 'package:flutter/material.dart';
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

        return Column(
          children: [
            AppBar(
              leading: IconButton(
                onPressed: () {
                  ref
                      .read(folderProvider(input).notifier)
                      .changeDir(path.dirname(data.fullPath));
                },
                icon: const Icon(Icons.arrow_back),
              ),
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
                itemCount: folderList.length + fileList.length + 1,
                itemBuilder: (context, index) {
                  final realIndex =
                      index - 1; // accounting for current directory tile
                  if (index == 0) {
                    return CurrentDirTile(currentDirPath: data.fullPath);
                  }

                  if (folderList.length > realIndex) {
                    final folder = folderList[realIndex];

                    if (searchController.text.isEmpty) {
                      return FolderTile(
                        folder: folder,
                        tabIndex: input,
                        clearSearch: searchController.clear,
                      );
                    }

                    if (path
                        .basename(folder.fullPath)
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return FolderTile(
                        folder: folder,
                        tabIndex: input,
                        clearSearch: searchController.clear,
                      );
                    }

                    return const SizedBox();
                  }

                  final file = fileList.elementAt(
                    realIndex - folderList.length,
                  );

                  if (searchController.text.isEmpty) {
                    return FileTile(file: file, parentPath: data.fullPath);
                  }

                  if (path
                      .basename(file.name)
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())) {
                    return FileTile(file: file, parentPath: data.fullPath);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        );
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
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void refreshDir(Folder data) {
    ref.read(folderProvider(input).notifier).refreshDir(data.fullPath);
  }
}

class NewFolderDialog extends StatefulWidget {
  const NewFolderDialog({required this.parentPath, super.key});

  final String parentPath;

  @override
  State<NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<NewFolderDialog> {
  late final TextEditingController controller;

  String get parentPath => widget.parentPath;

  String get fullPath => '$parentPath/${controller.text}';

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(
      () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 100),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            labelText: 'Folder Name',
          ),
        ),
        Text(fullPath),
        ElevatedButton(
          onPressed: controller.text.isEmpty
              ? null
              : () {
                  fs.createFolder(Path(path: fullPath));
                  Navigator.of(context, rootNavigator: true).pop();
                },
          child: const Text('Create Folder'),
        )
      ],
    );
  }
}

class FolderTile extends ConsumerWidget {
  const FolderTile({
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
      leading: const Icon(Icons.folder),
      title: Text(path.basename(folder.fullPath)),
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

class CurrentDirTile extends ConsumerWidget {
  const CurrentDirTile({
    required this.currentDirPath,
    super.key,
  });

  final String currentDirPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(path.basename('.')),
      trailing: HardlinkButtons(
        fPath: currentDirPath,
        parentPath: currentDirPath,
      ),
    );
  }
}

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

                    if (parentPath != null && fPath == parentPath) {
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
