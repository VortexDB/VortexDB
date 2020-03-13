import 'dart:convert';
import 'dart:io';

import 'package:binary_data/binary_data.dart';
import 'package:vortexdb/common/console/console_client_socket.dart';

/// For user interaction with vortexdb in console
class ConsoleClient {
  /// Start session with database in interactive mode
  Future start(String host, int port) async {
    print('Connecting to $host:$port');
    final socket = await Socket.connect(host, port);
    print('Connected');
    final clientSocket = ConsoleClientSocket(socket);

    final reader = BinaryStreamReader(socket);
    try {
      while (true) {
        final data = await reader.readStringWithLength();
        stdout.writeln(data);
        stdout.write('> ');

        final command = stdin.readLineSync();
        clientSocket.send(command);
      }
    } catch (_) {
      //
    }

    exit(0);
  }
}
