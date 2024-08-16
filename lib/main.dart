import 'package:alt/presentation/folder_view.dart';
import 'package:alt/presentation/hardlink_bar.dart';
import 'package:alt/providers/filesystem_provider.dart';
import 'package:alt/services/fs_client.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLogger();
  await FsService().init('8080');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreenAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Row(
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
      bottomNavigationBar: HardlinkBar(),
    );
  }
}
