import 'dart:async';
import 'dart:developer';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/utils.dart';
import 'package:myputt/utils/enums.dart';

class SigninService {
  final ScreenController _screenController = locator.get<ScreenController>();
  late StreamController<AppScreenState> controller;
  late Stream<AppScreenState> siginStream;
  final AuthService _authService = locator.get<AuthService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  String errorMessage = '';

  AppScreenState currentAppScreenState = AppScreenState.notLoggedIn;

  SigninService() {
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
    }

    bool fetchUserSuccess;
    try {
      fetchUserSuccess =
          await _userRepository.fetchCurrentUser().timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      errorMessage = 'Failed to connect';
      fetchUserSuccess = false;
    }
    if (!fetchUserSuccess) {
      errorMessage = 'Failed to load user';
      return false;
    }

    try {
      await fetchRepositoryData().timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
    }
    controller.add(AppScreenState.setup);
    currentAppScreenState = AppScreenState.setup;
    return true;
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

    try {
      await fetchRepositoryData().timeout(standardTimeout);
    } catch (e, trace) {
      errorMessage = 'Failed to load your history';
      log('failed to fetch repository data: $e');
      log(trace.toString());
      return false;
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
    final bool? isSetUp = await _authService.userIsSetup();
    if (isSetUp == null || !isSetUp) {
      return false;
    }
    if (newUser == null) {
      return false;
    }
    _userRepository.currentUser = newUser;
    controller.add(AppScreenState.loggedIn);
    currentAppScreenState = AppScreenState.loggedIn;
    return true;
  }

  void signOut() {
    clearRepositoryData();
    _authService.logOut();
    controller.add(AppScreenState.notLoggedIn);
    currentAppScreenState = AppScreenState.notLoggedIn;
  }
}
