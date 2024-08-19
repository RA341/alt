import 'dart:async';

import 'package:alt/core/system/providers/provider.server_connection.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckServerStatus extends ConsumerStatefulWidget {
  const CheckServerStatus({super.key});

  @override
  ConsumerState createState() => _CheckServerStatusState();
}

class _CheckServerStatusState extends ConsumerState<CheckServerStatus> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      print('checking connection');
      ref.invalidate(checkGRPCConnectionProvider);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(checkGRPCConnectionProvider);

    return connectionState.when(
      data: (data) {
        print(data);
        return data
            ? const Text('Connected', style: TextStyle(color: Colors.green))
            : const Text('Disconnected', style: TextStyle(color: Colors.red));
      },
      error: (error, stackTrace) {
        logger.d('Failed to connect to server', error: error);
        return Text('Error occurred $error');
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
