import 'package:VortexDB/console_server/console_server.dart';

/// Основной класс запускающий всё
class VortexDB {
  /// Запускает сервер
  void start() async {
    await ConsoleServer().start('0.0.0.0', 26301);
  }
}
