import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityServiceViewModel {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityServiceViewModel() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _controller.add(results.isNotEmpty && results.first != ConnectivityResult.none);
    });
  }

  Future<bool> get isConnected async {
    var result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }
}