import 'package:alt/grpc/channel/connection.dart' as impl;
import 'package:alt/protos/filesystem.pbgrpc.dart';
import 'package:alt/protos/system.pbgrpc.dart';

final grpClient = GRPCService();
final fs = grpClient.fs;
final sys = grpClient.sys;


class GRPCService {
  factory GRPCService() => _instance;

  GRPCService._internal();

  static final GRPCService _instance = GRPCService._internal();

  late FilesystemClient _fsClient;
  late SystemClient _sysClient;

  void initClients(String baseUrl, String port) {
    _fsClient = FilesystemClient(impl.createChannel(baseUrl, port));
    _sysClient = SystemClient(impl.createChannel(baseUrl, port));
  }

  SystemClient get sys => _sysClient;
  FilesystemClient get fs => _fsClient;
}
