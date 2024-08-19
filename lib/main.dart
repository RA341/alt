import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/navigation/ui/scaffhold_selector.dart';
import 'package:alt/services/logger.dart';
import 'package:alt/core/settings/service.prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLogger();
  await prefs.init();

  grpClient.initClients(
    prefs.prefs.getString(PrefsKeys.baseNameKey) ?? 'localhost',
    prefs.prefs.getString(PrefsKeys.portKey) ?? '8080',
  );

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
    return const ScaffholdSelector();
  }
}
