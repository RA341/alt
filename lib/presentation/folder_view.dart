import 'package:alt/protos/filesystem.pb.dart';
import 'package:alt/protos/filesystem.pbgrpc.dart';
import 'package:alt/providers/filesystem_provider.dart';
import 'package:alt/providers/hardlink_provider.dart';
import 'package:alt/services/fs_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class FolderView extends ConsumerStatefulWidget {
  const FolderView({
    required this.tabIndex,
    super.key,
  });

  final int tabIndex;

  @override
  ConsumerState createState() => _FolderViewState();
}

class _FolderViewState extends ConsumerState<FolderView> {
  int get tabIndex => widget.tabIndex;

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
    final folder = ref.watch(folderProvider(tabIndex));

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
                      .read(folderProvider(tabIndex).notifier)
                      .changeDir(path.dirname(data.fullPath));
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: NewFolderDialog(parentPath: data.fullPath),
                        );
                      },
                    );
                    ref.invalidate(getFolderProvider(data.fullPath));
                    ref.invalidate(folderProvider(tabIndex));
                  },
                  icon: const Icon(Icons.create_new_folder),
                ),
                IconButton(
                  onPressed: () async {
                    ref.invalidate(getFolderProvider(data.fullPath));
                    ref.invalidate(folderProvider(tabIndex));
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(data.fullPath),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: folderList.length + fileList.length,
                itemBuilder: (context, index) {
                  if (folderList.length > index) {
                    final folder = folderList[index];

                    if (searchController.text.isEmpty) {
                      return FolderTile(folder: folder, tabIndex: tabIndex);
                    }

                    if (path
                        .basename(folder.fullPath)
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return FolderTile(folder: folder, tabIndex: tabIndex);
                    }

                    return const SizedBox();
                  }

                  final file = fileList.elementAt(
                    index - folderList.length,
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
                  ref.invalidate(folderProvider(tabIndex));
                },
                icon: const Icon(Icons.refresh),
              )
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class NewFolderDialog extends StatefulWidget {
  const NewFolderDialog({super.key, required this.parentPath});

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
                  FsService.i.client.createFolder(
                    Path(path: fullPath),
                  );
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
    super.key,
    required this.folder,
    required this.tabIndex,
  });

  final Folder folder;
  final int tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(path.basename(folder.fullPath)),
      onTap: () async {
        ref.read(folderProvider(tabIndex).notifier).changeDir(folder.fullPath);
      },
      trailing: HardlinkButtons(path: folder.fullPath),
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
        path: '$parentPath/${file.name}',
        isFile: true,
      ),
    );
  }
}

class HardlinkButtons extends ConsumerWidget {
  const HardlinkButtons({
    super.key,
    required this.path,
    this.isFile = false,
  });

  final bool isFile;
  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final src = ref.watch(srcPathProvider);
    final isSrcSelected = src == path;

    final dest = ref.watch(destPathProvider);
    final isDestSelected = dest == path;

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
                  ref.read(srcPathProvider.notifier).state = path;
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSrcSelected ? Colors.blue : null,
          ),
          child: const Text('Hardlink Source'),
        ),
        const SizedBox(width: 10),
        if (!isFile) // we don't want a file as the hardlink destination
          ElevatedButton(
            onPressed: isSrcSelected
                ? null
                : () {
                    if (isDestSelected) {
                      ref.read(destPathProvider.notifier).state = '';
                      return;
                    }
                    ref.read(destPathProvider.notifier).state = path;
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestSelected ? Colors.lightGreen : null,
            ),
            child: const Text('Hardlink Destination'),
          ),
      ],
    );
  }
}
