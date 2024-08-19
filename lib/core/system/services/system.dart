import 'dart:io';

import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/protos/system.pb.dart';
import 'package:alt/services/logger.dart';
import 'package:flutter/foundation.dart';

class SystemControls {
  static Future<void> reboot() async {
    await sys.restart(Empty());
  }

  static Future<void> shutdown() async {
    await sys.shutdown(Empty());
  }

  static Future<void> sleep() async {
    await sys.sleep(Empty());
  }

  static Future<void> start(
    String macAddress, {
    String ipAddress = '255.255.255.255',
    int port = 9,
  }) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    try {
      final magicPacket = createMagicPacket(macAddress);

      final broadcastAddress =
          InternetAddress('255.255.255.255'); // Broadcast address
      const port = 9; // WoL port

      socket
        ..broadcastEnabled = true // Enable broadcasting
        ..send(magicPacket, broadcastAddress, port);

      logger.i('WOL packet sent to $macAddress');
    } catch (e) {
      logger.e('Error sending WOL packet', error: e);
    } finally {
      socket.close();
    }
  }

  static Uint8List createMagicPacket(String macAddress) {
    final macBytes =
        macAddress.split(':').map((s) => int.parse(s, radix: 16)).toList();
    final magicPacket = Uint8List(102)
      ..fillRange(0, 6, 0xFF); // Fill the magic packet with 6 bytes of 0xFF

    // Repeat the target MAC address 16 times
    for (var i = 6; i < 102; i += 6) {
      magicPacket.setRange(i, i + 6, macBytes);
    }

    return magicPacket;
  }
}
