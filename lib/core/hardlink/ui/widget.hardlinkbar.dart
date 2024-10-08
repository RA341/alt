import 'package:alt/core/hardlink/providers/provider.hardlink.dart';
import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class HardlinkBar extends ConsumerStatefulWidget {
  const HardlinkBar({super.key});

  @override
  ConsumerState createState() => _HardlinkBarState();
}

class _HardlinkBarState extends ConsumerState<HardlinkBar> {
  late final TextEditingController srcController = TextEditingController();
  late final TextEditingController destController = TextEditingController();

  @override
  void dispose() {
    srcController.dispose();
    destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinDest = ref.watch(pinDestinationLocationProvider);
    final autofill = ref.watch(autofillDestinationProvider);

    ref
      ..listen(
        srcPathProvider,
        (_, newString) {
          final currentCursorPosition = srcController.selection.base.offset;
          srcController.text = newString;

          try {
            if (newString.isNotEmpty) {
              srcController.selection = TextSelection.fromPosition(
                TextPosition(offset: currentCursorPosition),
              );
            }
          } catch (e) {
            logger.d(
              'watch it dumb dumb',
              error: e,
            );
          }
          setState(() {});
        },
      )
      ..listen(
        destPathProvider,
        (_, newString) {
          final currentCursorPosition = destController.selection.base.offset;
          destController.text = newString;

          if (newString.isNotEmpty) {

            try {
              destController.selection = TextSelection.fromPosition(
                TextPosition(offset: currentCursorPosition),
              );
            } catch (e) {
              logger.d(
                'This probably occurred, destination was pinned and autofill is enabled',
                error: e,
              );
            }
          }
          setState(() {});
        },
      );

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
                      onChanged: (value) =>
                          ref.read(srcPathProvider.notifier).state = value,
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
                      onChanged: (value) =>
                          ref.read(destPathProvider.notifier).state = value,
                      decoration: addTextFieldDecoration(
                        'Destination Path',
                        destController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: ref.read(destPathProvider).isNotEmpty &&
                          ref.read(srcPathProvider).isNotEmpty
                      ? hardlinkFiles
                      : null,
                  child: const Text(
                    'Hardlink',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(width: 130),
                const Text(
                  'Pin Destination:',
                  style: TextStyle(fontSize: 17),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(pinDestinationLocationProvider.notifier).state =
                        !pinDest;
                  },
                  icon: Icon(
                    pinDest ? Icons.push_pin : Icons.push_pin_outlined,
                  ),
                ),
                const SizedBox(width: 75),
                const Text(
                  'Autofill Destination folder:',
                  style: TextStyle(fontSize: 17),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(autofillDestinationProvider.notifier).state =
                        !autofill;
                  },
                  icon: Icon(
                    autofill
                        ? Icons.auto_fix_normal_rounded
                        : Icons.auto_fix_off_rounded,
                  ),
                ),
                const SizedBox(width: 125),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> hardlinkFiles() async {
    final input = InputFolders(
      srcPath: srcController.text,
      destPath: destController.text,
    );

    try {
      await fs.linkFolder(input);

      if (!ref.read(pinDestinationLocationProvider)) {
        ref.invalidate(destPathProvider);
      } else {
        final dest = path.dirname(destController.text);
        ref.read(destPathProvider.notifier).state = dest;
      }

      ref.invalidate(srcPathProvider);
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
    ),
  );
}
