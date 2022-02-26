import 'dart:async';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/app_info_data_loader.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'package:myputt/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SigninService {
  late StreamController<LoginState> controller;
  late Stream<LoginState> siginStream;
  final _authService = locator.get<AuthService>();
  late final String _version;
  LoginState currentLoginState = LoginState.none;
  SigninService() {
    controller = StreamController<LoginState>();
    siginStream = controller.stream;
  }

  Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    if (_authService.getCurrentUserId() != null) {
      if (!(await _authService.userIsSetup())) {
        controller.add(LoginState.setup);
        currentLoginState = LoginState.setup;
      } else {
        final String? minimumVersion = await getMinimumAppVersion();
        if (minimumVersion == null) {
          controller.add(LoginState.loggedIn);
          return;
        }
        if (versionToNumber(minimumVersion) > versionToNumber(_version)) {
          controller.add(LoginState.forceUpgrade);
          return;
        }
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
    final String? minimumVersion = await getMinimumAppVersion();
    if (minimumVersion != null) {
      if (versionToNumber(minimumVersion) > versionToNumber(_version)) {
        controller.add(LoginState.forceUpgrade);
        return true;
      }
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
    final String? minimumVersion = await getMinimumAppVersion();
    if (minimumVersion != null) {
      if (versionToNumber(minimumVersion) > versionToNumber(_version)) {
        controller.add(LoginState.forceUpgrade);
        return true;
      }
    }
    await fetchRepositoryData();
    controller.add(LoginState.loggedIn);
    currentLoginState = LoginState.loggedIn;
    return true;
  }

  Future<bool> setupNewUser(String username, String displayName,
      {int? pdgaNumber}) async {
    final bool setupNewUserSuccess = await _authService
        .setupNewUser(username, displayName, pdgaNumber: pdgaNumber);
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
