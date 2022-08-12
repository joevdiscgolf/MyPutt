import 'dart:async';
import 'dart:developer';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/utils.dart';
import 'package:myputt/utils/enums.dart';

class MyPuttAuthService {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  final ScreenController _screenController = locator.get<ScreenController>();
  late StreamController<AppScreenState> controller;
  late Stream<AppScreenState> siginStream;
  final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  String errorMessage = '';

  AppScreenState currentAppScreenState = AppScreenState.notLoggedIn;

  MyPuttAuthService() {
    controller = _screenController.controller;
  }

  Future<bool> attemptSignUpWithEmail(String email, String password) async {
    bool signUpSuccess = false;
    try {
      signUpSuccess = await _authService
          .signUpWithEmail(email, password)
          .timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      errorMessage = 'Failed to connect';
      signUpSuccess = false;
    }

    if (!signUpSuccess || _authService.getCurrentUserId() == null) {
      errorMessage = _authService.exception;
      return false;
    } else {
      controller.add(AppScreenState.setup);
      currentAppScreenState = AppScreenState.setup;
      return true;
    }
  }

  Future<bool> attemptSignInWithEmail(String email, String password) async {
    bool signInSuccess = false;
    try {
      signInSuccess = await _authService
          .signInWithEmail(email, password)
          .timeout(shortTimeout);
    } on Exception catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      errorMessage = 'Failed to connect';
      return false;
    }

    if (!signInSuccess || _authService.getCurrentUserId() == null) {
      errorMessage = _authService.exception;
      return false;
    }

    final bool? isSetup = await _authService.userIsSetup();

    if (isSetup == null) {
      errorMessage = 'Something went wrong, please try again.';
      return false;
    } else if (!isSetup) {
      controller.add(AppScreenState.setup);
      currentAppScreenState = AppScreenState.setup;
      return true;
    }

    _mixpanel.track(
      'Sign in',
      properties: {'Uid': _authService.getCurrentUserId()},
    );

    try {
      await fetchRepositoryData().timeout(standardTimeout);
    } catch (e, trace) {
      log('[myputt_auth_service][attemptSigninWithEmail] Failed to fetch repository data. Error: $e');
      log(trace.toString());
    }
    controller.add(AppScreenState.loggedIn);
    currentAppScreenState = AppScreenState.loggedIn;
    return true;
  }

  Future<bool> setupNewUser(
    String username,
    String displayName, {
    int? pdgaNumber,
  }) async {
    final MyPuttUser? newUser = await _authService
        .setupNewUser(username, displayName, pdgaNumber: pdgaNumber);
    if (newUser == null) {
      return false;
    }
    final bool? isSetUp = await _authService.userIsSetup();
    if (isSetUp == null || !isSetUp) {
      return false;
    }

    _mixpanel.track(
      'New User Set Up',
      properties: {'Uid': newUser.uid, 'Username': username},
    );

    _userRepository.currentUser = newUser;
    controller.add(AppScreenState.loggedIn);
    currentAppScreenState = AppScreenState.loggedIn;
    return true;
  }

  void signOut() {
    _mixpanel.track(
      'Log out',
      properties: {'Uid': _authService.getCurrentUserId()},
    );
    clearRepositoryData();
    _authService.logOut();
    controller.add(AppScreenState.notLoggedIn);
    currentAppScreenState = AppScreenState.notLoggedIn;
  }
}
