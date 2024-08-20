import 'package:alt/core/settings/service.prefs.dart';
import 'package:alt/grpc/grpc_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkGRPCConnectionProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  return grpClient.testConnection(prefs.baseUrl, prefs.port);
});
