import 'dart:async';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

class SigninService {
  late StreamController<bool> controller;
  late Stream<bool> siginStream;
  final _authService = locator.get<AuthService>();
  SigninService() {
    controller = StreamController<bool>();
    siginStream = controller.stream;
    if (_authService.getCurrentUserId() != null) {
      controller.add(true);
    }
  }

  Future<bool> attemptSignIn(String email, String password) async {
    final bool? signInSuccess = await _authService.signInWithEmail(email, password);
    if (signInSuccess == null || !signInSuccess || _authService.getCurrentUserId() == null) {
      return false;
    }
    await locator.get<SessionRepository>().fetchCurrentSession();
    await locator.get<SessionRepository>().fetchCompletedSessions();
      controller.add(true);
      print('added event');
      return true;

  }

  void signOut() {
    controller.add(false);
  }

}