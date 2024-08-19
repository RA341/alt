import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/services/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefs = PrefsManager();
final kPrefs = PrefsKeys();

class PrefsManager {
  factory PrefsManager() => _instance;

  PrefsManager._internal();

  static final PrefsManager _instance = PrefsManager._internal();

  late final SharedPreferences prefs;

  String get baseUrl => prefs.getString(PrefsKeys.baseNameKey) ?? 'localhost';
  String get port => prefs.getString(PrefsKeys.portKey) ?? '8080';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> updatePortAndBaseUrl(String baseName, String port) async {
    await prefs.setString(PrefsKeys.baseNameKey, baseName);
    await prefs.setString(PrefsKeys.portKey, port);
    await prefs.reload();

    final bUrl = prefs.getString(PrefsKeys.baseNameKey) ?? 'localhost';
    final newPort = prefs.getString(PrefsKeys.portKey) ?? '8080';

    logger.d('Reinitialized client with $bUrl:$newPort');

    grpClient.initClients(bUrl, newPort);
  }
}

class PrefsKeys {
  static const baseNameKey = 'basename';
  static const portKey = 'port';
}
