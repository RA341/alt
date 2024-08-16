//
//  Generated code. Do not modify.
//  source: protos/system.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'system.pb.dart' as $0;

export 'system.pb.dart';

@$pb.GrpcServiceName('fs.System')
class SystemClient extends $grpc.Client {
  static final _$shutdown = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/fs.System/Shutdown',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$restart = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/fs.System/Restart',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$sleep = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/fs.System/Sleep',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  SystemClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Empty> shutdown($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$shutdown, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> restart($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restart, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> sleep($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sleep, request, options: options);
  }
}

@$pb.GrpcServiceName('fs.System')
abstract class SystemServiceBase extends $grpc.Service {
  $core.String get $name => 'fs.System';

  SystemServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Shutdown',
        shutdown_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Restart',
        restart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Sleep',
        sleep_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> shutdown_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return shutdown(call, await request);
  }

  $async.Future<$0.Empty> restart_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return restart(call, await request);
  }

  $async.Future<$0.Empty> sleep_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return sleep(call, await request);
  }

  $async.Future<$0.Empty> shutdown($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> restart($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> sleep($grpc.ServiceCall call, $0.Empty request);
}
