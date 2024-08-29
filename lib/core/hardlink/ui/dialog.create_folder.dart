import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:flutter/material.dart';

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
                  fs.createFolder(NewPath(
                    path: fullPath,
                    anchorPath: parentPath,
                  ));
                  Navigator.of(context, rootNavigator: true).pop();
                },
          child: const Text('Create Folder'),
        )
      ],
    );
  }
}
