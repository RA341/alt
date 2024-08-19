import 'package:alt/core/hardlink/providers/filesystem_provider.dart';
import 'package:alt/core/hardlink/ui/hardlink_bar.dart';
import 'package:alt/services/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChangeServerUrl(),
        ],
      ),
    );
  }
}

class ChangeServerUrl extends ConsumerStatefulWidget {
  const ChangeServerUrl({super.key});

  @override
  ConsumerState<ChangeServerUrl> createState() => _ChangeServerUrlState();
}

class _ChangeServerUrlState extends ConsumerState<ChangeServerUrl> {
  late final TextEditingController urlController = TextEditingController(
    text: prefs.prefs.getString(PrefsKeys.baseNameKey),
  );
  late final TextEditingController portController = TextEditingController(
    text: prefs.prefs.getString(PrefsKeys.portKey),
  );

  @override
  void dispose() {
    urlController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: urlController,
                      decoration: addTextFieldDecoration(
                        'Base URL',
                        urlController,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: portController,
                      decoration: addTextFieldDecoration(
                        'Port',
                        portController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text('Change Url'),
                onPressed: () async {
                  await prefs.updatePortAndBaseUrl(
                    urlController.text,
                    portController.text,
                  );

                  if (!context.mounted) return;

                  ref
                    ..invalidate(fetchFolderProvider)
                    ..invalidate(folderProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Updated base url'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
