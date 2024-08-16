import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PrefsManager {
  Future<void> init() async {
    final extDir = await getApplicationDocumentsDirectory();
    final logFile = await File('${extDir.path}/alt/alt.log').create(recursive: true);



  }

}
