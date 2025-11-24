import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionHelper {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
           connectivityResult.contains(ConnectivityResult.wifi) ||
           connectivityResult.contains(ConnectivityResult.ethernet);
  }

  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
