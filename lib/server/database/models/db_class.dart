import 'package:vortexdb/server/database/models/db_entity.dart';

/// Database class for storing
class DBClass extends DBEntity {
  /// Имя класса
  final String name;

  /// Конструктор
  DBClass(String id, this.name) : super(id);  
}