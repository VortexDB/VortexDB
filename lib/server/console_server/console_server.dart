import 'dart:convert';
import 'dart:io';

import 'package:vortexdb/server/console_server/command_factory.dart';

/// Сервер обрабатывающий консольные команты
class ConsoleServer {
  /// Starts server
  void start(String host, int port) async {
    final server = await ServerSocket.bind(host, port);

    server.listen((client) {
      client.write('Welcome to VortexDB!');
          
      client.listen((data) async {
        final dataStr = utf8.decode(data);
        final items = dataStr.split(' ');
        final name = items[0];
        final command = CommandFactory.instance.getCommand(name);
        if (command != null) {
          await command.process(client, items.sublist(1));
        } else {
          client.write('Unknown command');
        }
      });
    });
  }
}
