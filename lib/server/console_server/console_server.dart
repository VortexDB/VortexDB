import 'dart:convert';
import 'dart:io';

import 'package:binary_data/binary_data.dart';
import 'package:vortexdb/common/console/console_client_socket.dart';
import 'package:vortexdb/server/console_server/command_factory.dart';

/// Сервер обрабатывающий консольные команты
class ConsoleServer {
  /// Starts server
  void start(String host, int port) async {
    final server = await ServerSocket.bind(host, port);

    print('Console server started ${host}:${port}');

    server.listen((socket) async {
      print('Console client connected');
      final clientSocket = ConsoleClientSocket(socket);

      clientSocket.send('Welcome to VortexDB!');

      final reader = BinaryStreamReader(socket);
      try {
        while (true) {
          final data = await reader.readStringWithLength();
          final items = data.split(' ');
          final name = items[0];
          final command = CommandFactory.instance.getCommand(name);
          if (command != null) {
            await command.process(clientSocket, items.sublist(1));
          } else {
            socket.write('Unknown command');
          }
        }
      } catch (e) {
        //print(e);
      }
    });
  }
}
