import 'package:alt/grpc/channel/connection.dart' as impl;
import 'package:alt/protos/filesystem.pbgrpc.dart';

final grpClient = GRPCService();
final fs = grpClient.fs;

class GRPCService {
  factory GRPCService() => _instance;

  GRPCService._internal();

  static final GRPCService _instance = GRPCService._internal();

  late FilesystemClient _fsClient;

  void initClients(String baseUrl, String port) {
    _fsClient = FilesystemClient(impl.createChannel(baseUrl, port));
  }

  FilesystemClient get fs => _fsClient;
}
