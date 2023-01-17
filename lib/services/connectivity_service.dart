import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/utils/helpers.dart';
import 'package:myputt/utils/utils.dart';

class ConnectivityService {
  ConnectivityService() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (_previousConnectivityResult == null ||
          (!isConnected(_previousConnectivityResult!) && isConnected(result))) {
        _onConnected();
      }
    });
  }

  ConnectivityResult? _previousConnectivityResult;
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _onConnected() async {
    await locator.get<SessionRepository>().saveUnsyncedSessions();
  }
}
