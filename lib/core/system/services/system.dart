import 'dart:io';

import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/protos/system.pb.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter/foundation.dart';

class SystemControls {
  Future<void> reboot() async {
    await sys.restart(Empty());
  }

  Future<void> shutdown() async {
    await sys.shutdown(Empty());
  }

  Future<void> sleep() async {
    await sys.sleep(Empty());
  }

  Future<void> start(
    String macAddress, {
    String ipAddress = '255.255.255.255',
    int port = 9,
  }) async {
    // Parse the MAC address
    final mac =
        macAddress.split(':').map((e) => int.parse(e, radix: 16)).toList();

    // Create the magic packet
    final packet = ByteData(102);

    // First 6 bytes are 0xFF
    for (var i = 0; i < 6; i++) {
      packet.setUint8(i, 0xFF);
    }

    // Repeat MAC address 16 times
    for (var i = 1; i <= 16; i++) {
      packet.buffer.asUint8List().setRange(i * 6, i * 6 + 6, mac);
    }

    // Create UDP socket
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    try {
      // Send the packet
      socket.send(
          packet.buffer.asUint8List(), InternetAddress(ipAddress), port);
      logger.i('WOL packet sent to $macAddress');
    } catch (e) {
      logger.e('Error sending WOL packet', error: e);
    } finally {
      socket.close();
    }
  }
}
