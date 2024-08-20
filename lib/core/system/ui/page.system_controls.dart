import 'package:alt/core/system/ui/widget.system_buttons.dart';
import 'package:alt/core/system/ui/widget.system_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemControls extends ConsumerWidget {
  const SystemControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: SystemInfo(),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: SystemButtons(),
        ),
      ],
    );
  }
}
