import 'dart:async';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

class SigninService {
  StreamController<bool>? controller;
  Stream<bool>? siginStream;
  final _authService = locator.get<AuthService>();
  SigninService() {
    StreamController<bool> controller = StreamController<bool>();
    Stream signinStream = controller.stream;
  }

  Future<bool> attemptSignIn(String email, String password) async {
    final bool? signInSuccess = await _authService.signInWithEmail(email, password);
    if (signInSuccess == null || !signInSuccess || _authService.getCurrentUserId() == null) {
      return false;
    }
    await locator.get<SessionRepository>().fetchCurrentSession;
    await locator.get<SessionRepository>().fetchCompletedSessions;
    if (controller != null) {
      controller?.add(true);
      return true;
    } else {
      return false;
    }

  }

}