import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bwys/config/application.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketServiceBloc
    extends Bloc<WebSocketServiceEvent, WebSocketServiceState> {
  Socket? connection;

  WebSocketServiceBloc() : super(const NoConnectionExistState());

  @override
  Stream<WebSocketServiceState> mapEventToState(
    WebSocketServiceEvent event,
  ) async* {
    if (event is MakeHandshakeConnection) {
      yield* _mapMakeHandshakeConnectionEventToState(event);
    } else if (event is HandshakeConnectionMade) {
      yield HandShakeConnectionMadeState(connection: connection);
    } else if (event is HandshakeConnectionError) {
      yield const HandShakeConnectionErrorState();
    }
  }

  Stream<WebSocketServiceState> _mapMakeHandshakeConnectionEventToState(
      MakeHandshakeConnection event) async* {
    /// Make Handshake connection
    int _length = Application.storageService!.syncedWebUrl!.length;

    /// Check if syncedWebUrl contains / in last reduce the length
    if (Application.storageService!.syncedWebUrl![
            Application.storageService!.syncedWebUrl!.length - 1] ==
        '/') {
      _length--;
    }

    connection = IO.io(
        Application.storageService!.syncedWebUrl!.substring(0, _length),
        OptionBuilder()
            .setTransports(['websocket'])
            .setPath('/ws/')
            .setExtraHeaders({'Authorization': BWYSUser.userToken})
            .enableReconnection()
            .disableAutoConnect()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(double.infinity)
            .build());

    /// Request for connection
    connection!.connect();

    /// Check the status of the connection and yield the state
    yield* _mapConnectionStatusToState();
  }

  Stream<WebSocketServiceState> _mapConnectionStatusToState() async* {
    connection!.onConnecting((_) =>
        Application.logService!.log('Web Socket Status :: CONNECTING...'));
    connection!.onConnect((_) {
      add(const HandshakeConnectionMade());
      Application.logService!.log('Web Socket Status :: CONNECTED');
    });
    connection!.onConnectError((error) {
      add(const HandshakeConnectionError());
      Application.logService!
          .log('Web Socket Handshake Connection Error :: $error');
    });
    connection!.onReconnecting((_) =>
        Application.logService!.log('Web Socket Status :: RE-CONNECTING...'));
    connection!.onReconnect((_) {
      add(const HandshakeConnectionMade());
      Application.logService!.log('Web Socket Status :: RE-CONNECTED');
    });
    connection!.onReconnectError((error) {
      add(const HandshakeConnectionError());
      Application.logService!
          .log('Web Socket Handshake Re-Connection Error :: $error');
    });
    connection!.onReconnectFailed((error) {
      add(const HandshakeConnectionError());
      Application.logService!
          .log('Web Socket Handshake Re-Connection Failed :: $error');
    });
    connection!.onConnectTimeout((error) {
      add(const HandshakeConnectionError());
      Application.logService!
          .log('Web Socket Handshake Timeout Error :: $error');
    });
    connection!.onDisconnect((_) {
      add(const HandshakeConnectionError());
      Application.logService!.log('Web Socket Status :: DISCONNECTED');
    });
  }

  void removeHandshake() {
    connection!.disconnect();
    connection!.dispose();
  }
}
