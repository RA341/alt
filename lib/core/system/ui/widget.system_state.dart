import 'package:alt/core/system/ui/widget.server_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemInfo extends ConsumerWidget {
  const SystemInfo({super.key});

  static const systemButtonPadding = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.all(systemButtonPadding),
            child: Text('Mac address:'),
          ),
          // Padding(
          //   padding: EdgeInsets.all(systemButtonPadding),
          //   child: CheckServerStatus(),
          // ),
          Padding(
            padding: EdgeInsets.all(systemButtonPadding),
            child: Text('IP:'),
          ),
        ],
      ),
    );
  }
}
