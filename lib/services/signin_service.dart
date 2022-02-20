import 'dart:async';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/utils.dart';
import 'package:myputt/utils/constants.dart';

class SigninService {
  late StreamController<LoginState> controller;
  late Stream<LoginState> siginStream;
  final _authService = locator.get<AuthService>();
  LoginState currentLoginState = LoginState.none;
  SigninService() {
    controller = StreamController<LoginState>();
    siginStream = controller.stream;
  }

  Future<void> init() async {
    if (_authService.getCurrentUserId() != null) {
      if (!(await _authService.userIsSetup())) {
        controller.add(LoginState.setup);
        currentLoginState = LoginState.setup;
      } else {
        await fetchRepositoryData();
        controller.add(LoginState.loggedIn);
        currentLoginState = LoginState.loggedIn;
      }
    } else {
      controller.add(LoginState.none);
      currentLoginState = LoginState.none;
    }
  }

  Future<bool> attemptSignUp(String email, String password) async {
    print('attempting sign up');
    final bool? signUpSuccess =
        await _authService.signUpWithEmail(email, password);
    print(signUpSuccess);
    if (signUpSuccess == null ||
        !signUpSuccess ||
        _authService.getCurrentUserId() == null) {
      return false;
    }
    await fetchRepositoryData();
    controller.add(LoginState.setup);
    currentLoginState = LoginState.setup;
    return true;
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
    await fetchRepositoryData();
    controller.add(LoginState.loggedIn);
    currentLoginState = LoginState.loggedIn;
    return true;
  }

  Future<bool> setupNewUser(
      String username, String displayName, int? pdgaNumber) async {
    final bool setupNewUserSuccess =
        await _authService.setupNewUser(username, displayName, pdgaNumber);
    if (await _authService.userIsSetup()) {
      controller.add(LoginState.loggedIn);
      currentLoginState = LoginState.loggedIn;
    }
    return setupNewUserSuccess;
  }

  void signOut() {
    clearRepositoryData();
    _authService.logOut();
    controller.add(LoginState.none);
    currentLoginState = LoginState.none;
  }
}
