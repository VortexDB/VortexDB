import 'dart:io';

import 'package:binary_data/binary_data.dart';

/// Wrapper of socket
class ConsoleClientSocket {
  /// Socket to send data
  final Socket _socket;

  /// Constructor
  ConsoleClientSocket(this._socket);

  /// Send data to client
  void send(String data) {
    final binary = BinaryData();
    binary.writeStringWithLength(data);
    _socket.add(binary.getList());
  }

  /// Close socket
  Future close() {
    return _socket.close();
  }
}
