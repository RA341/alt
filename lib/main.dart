import 'package:alt/core/hardlink/providers/filesystem_provider.dart';
import 'package:alt/core/hardlink/ui/folder_view.dart';
import 'package:alt/core/hardlink/ui/hardlink_bar.dart';
import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLogger();
  grpClient.initClients('192.168.50.123', '8080');

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
          seedColor: Colors.purpleAccent,
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
