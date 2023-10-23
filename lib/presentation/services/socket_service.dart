import 'package:chat_app/config/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

enum ServerStatus { Online, Offline, Connecting }

class SocketService {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  socket_io.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;

  socket_io.Socket get socket => _socket!;

  Function get emit => _socket!.emit;

  // SocketService() {
  //   _initConfig();
  // }

  void connect() {
    // Dart client
    _socket = socket_io.io(Environments.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
    });

    _socket!.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      print('****** Estado del socket: $_serverStatus ***********');
    });

    print(
        '***** Estado fuera de la función connect $serverStatus ****************');

    _socket!.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
    });
  }

  void disconnect() {
    _socket!.disconnect();
  }
}
