import 'package:alt/protos/filesystem.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../protos/filesystem.pbgrpc.dart';
import 'channel/connection.dart' as impl;

class FsService {
  static const baseUrl = "192.168.50.123";

  FsService._internal();

  static final FsService _instance = FsService._internal();

  factory FsService() => _instance;

  static FsService get i => _instance;

  late FilesystemClient _greeterClient;

  Future<void> init(String port) async {
    _greeterClient = FilesystemClient(impl.createChannel(baseUrl, port));
  }

  FilesystemClient get client => _greeterClient;
}
