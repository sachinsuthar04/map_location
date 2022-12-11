import 'package:clean_framework/src/service/connectivity.dart';

class AlwaysOnlineConnectivity implements Connectivity {
  @override
  Future<ConnectivityStatus> getConnectivityStatus() {
    return Future.value(ConnectivityStatus.online);
  }

  @override
  void registerConnectivityChangeListener(listener) {
    listener(ConnectivityStatus.online);
  }
}
