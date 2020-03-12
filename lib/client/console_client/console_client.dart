import 'dart:convert';
import 'dart:io';

/// For user interaction with vortexdb in console
class ConsoleClient {
  /// Start session with database in interactive mode
  Future start(String host, int port) async {
    print('Connecting to $host:$port');
    final client = await Socket.connect(host, port);
    client.listen((event) async {
      stdout.writeln(utf8.decode(event));
      stdout.write('> ');
      final command = stdin.readLineSync();
      client.write(command);
    }, onDone: () {
      print('Console closed. Good bye.');
      exit(0);
    });
  }
}
