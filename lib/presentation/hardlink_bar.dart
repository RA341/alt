import 'package:alt/protos/filesystem.pb.dart';
import 'package:alt/providers/hardlink_provider.dart';
import 'package:alt/services/fs_client.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HardlinkBar extends ConsumerStatefulWidget {
  const HardlinkBar({super.key});

  @override
  ConsumerState createState() => _HardlinkBarState();
}

class _HardlinkBarState extends ConsumerState<HardlinkBar> {
  // late final Tex

  late final TextEditingController srcController;
  late final TextEditingController destController;

  @override
  void initState() {
    srcController = TextEditingController();
    destController = TextEditingController();

    srcController.addListener(
      () {
        ref.read(srcPathProvider.notifier).state = srcController.text;
      },
    );

    destController.addListener(
      () {
        ref.read(destPathProvider.notifier).state = destController.text;
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    srcController.dispose();
    destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    destController.text = ref.watch(destPathProvider);
    srcController.text = ref.watch(srcPathProvider);

    var buttonEnabled =
        destController.text.isNotEmpty && srcController.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Theme.of(context).colorScheme.primary.withAlpha(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: srcController,
                      decoration: addTextFieldDecoration(
                        'Source Path',
                        srcController,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: destController,
                      decoration: addTextFieldDecoration(
                        'Destination Path',
                        destController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: buttonEnabled
                  ? () async {
                      final input = InputFolders(
                        srcPath: srcController.text,
                        destPath: destController.text,
                      );

                      try {
                        await FsService.i.client.linkFolder(input);
                        ref
                          ..invalidate(srcPathProvider)
                          ..invalidate(destPathProvider);
                      } catch (e) {
                        logger.e(
                          'Error occurred while linking: ${srcController.text} ----> ${destController.text}',
                          error: e,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error occurred while hard linking $e',
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text(
                'Hardlink',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration addTextFieldDecoration(
    String hintText,
    TextEditingController controller,
  ) {
    return InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 100),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        labelText: hintText,
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: const Icon(Icons.clear),
        ));
  }
}
