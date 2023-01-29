import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/utils/utils.dart';

class ConnectivityService {
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((result) {
      _connectivityListener(result);
    });
    _initTimer();
  }

  ConnectivityResult? _connectivityResult;
  ConnectivityResult? get connectivityResult => _connectivityResult;

  void _connectivityListener(ConnectivityResult result) {
    if (_connectivityResult == null ||
        (!isConnected(_connectivityResult!) && isConnected(result))) {
      _onConnected();
    }
    _connectivityResult = result;
  }

  void _initTimer() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_connectivityResult != null && isConnected(_connectivityResult!)) {
        await locator.get<SessionRepository>().syncLocalSessionsToCloud();
      }
    });
  }

  Future<void> _onConnected() async {
    await locator.get<SessionRepository>().fetchCloudCompletedSessions();
    await locator.get<SessionRepository>().syncLocalSessionsToCloud();
  }
}
