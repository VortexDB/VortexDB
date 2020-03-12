import 'package:vortexdb/server/console_server/console_server.dart';

/// Основной класс запускающий всё
class ConsoleHost {
  /// Запускает сервер
  void start() async {
    await ConsoleServer().start('0.0.0.0', 26301);
  }
}
