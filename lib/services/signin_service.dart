import 'dart:async';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/utils.dart';

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
    print('attempting signin');
    final bool? signInSuccess =
        await _authService.signInWithEmail(email, password);
    print(signInSuccess);
    if (signInSuccess == null ||
        !signInSuccess ||
        _authService.getCurrentUserId() == null) {
      return false;
    }
    //await fetchRepositoryData();
    await locator.get<SessionRepository>().fetchCurrentSession();
    await locator.get<SessionRepository>().fetchCompletedSessions();
    controller.add(true);
    return true;
  }

  void signOut() {
    locator.get<SessionRepository>().clearData();
    _authService.logOut();
    controller.add(false);
  }
}
