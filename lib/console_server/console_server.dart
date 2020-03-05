import 'dart:io';

/// Сервер обрабатывающий консольные команты
class ConsoleServer {
  /// Запускает сервер
  void start(String host, int port) async {
    final server = await ServerSocket.bind(host, port);
    print('Console server started');
    server.listen((client) {
      client.writeln('Hello! Welcome to VortexDB\r');
      client.write('> ');
      client.listen((data) {
        print(data);
      });
    });
  }
}
