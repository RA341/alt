import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

late final Logger logger;

Future<void> initLogger() async {
  final extDir = await getExternalStorageDirectory();
  final logFile = await File('${extDir!.path}/rnr.log').create(recursive: true);

  logger = Logger(
    level: Level.all,
    filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    output: kDebugMode ? ConsoleOutput() : FileOutput(file: logFile),
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}
