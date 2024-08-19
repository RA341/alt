import 'package:alt/grpc/channel/connection.dart' as impl;
import 'package:alt/protos/filesystem.pbgrpc.dart';
import 'package:alt/protos/system.pbgrpc.dart';
import 'package:alt/services/logger.dart';

final grpClient = GRPCService();
final fs = grpClient.fs;
final sys = grpClient.sys;

class GRPCService {
  factory GRPCService() => _instance;

  GRPCService._internal();

  static final GRPCService _instance = GRPCService._internal();

  late FilesystemClient _fsClient;
  late SystemClient _sysClient;

  SystemClient get sys => _sysClient;

  FilesystemClient get fs => _fsClient;

  void initClients(String baseUrl, String port) {
    final channel = impl.createChannel(baseUrl, port);
    _fsClient = FilesystemClient(channel);
    _sysClient = SystemClient(channel);
  }

  Future<bool> testConnection(String baseUrl, String port) async {
    final channel = impl.createChannel(baseUrl, port);
    try {
      await channel.getConnection();
      return true;
    } catch (e) {
      logger.e('Failed to connect to server', error: e);
      return false;
    } finally {
      await channel.shutdown();
    }
  }
}
