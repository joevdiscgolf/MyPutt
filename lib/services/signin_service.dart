import 'dart:async';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/app_info_data_loader.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'package:myputt/utils/enums.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SigninService {
  final SharedPreferencesService _sharedPreferencesService =
      locator.get<SharedPreferencesService>();
  final ScreenController _screenController = locator.get<ScreenController>();
  late StreamController<AppScreenState> controller;
  late Stream<AppScreenState> siginStream;
  final AuthService _authService = locator.get<AuthService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  late final String _version;
  final Connectivity _connectivity = Connectivity();
  String errorMessage = '';

  AppScreenState currentAppScreenState = AppScreenState.notLoggedIn;
  SigninService() {
    controller = _screenController.controller;
  }

  Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    final ConnectivityResult _connectivityResult =
        await _connectivity.checkConnectivity();
    final bool? isFirstRun =
        await _sharedPreferencesService.getBooleanValue('isFirstRun');
    if (isFirstRun == null || isFirstRun) {
      controller.add(AppScreenState.firstRun);
    } else {
      if (!validConnectivityResults.contains(_connectivityResult)) {
        controller.add(AppScreenState.notLoggedIn);
      } else {
        if (_authService.getCurrentUserId() != null) {
          if (!(await _authService.userIsSetup())) {
            controller.add(AppScreenState.setup);
            currentAppScreenState = AppScreenState.setup;
          } else {
            final String? minimumVersion = await getMinimumAppVersion();
            if (minimumVersion == null) {
              controller.add(AppScreenState.loggedIn);
              return;
            }
            if (versionToNumber(minimumVersion) > versionToNumber(_version)) {
              controller.add(AppScreenState.forceUpgrade);
              return;
            }
            await fetchRepositoryData();
            controller.add(AppScreenState.loggedIn);
            currentAppScreenState = AppScreenState.loggedIn;
          }
        } else {
          controller.add(AppScreenState.notLoggedIn);
          currentAppScreenState = AppScreenState.notLoggedIn;
        }
      }
    }
  }

  Future<bool> attemptSignUpWithEmail(String email, String password) async {
    bool signUpSuccess = false;
    try {
      signUpSuccess = await _authService
          .signUpWithEmail(email, password)
          .timeout(const Duration(seconds: 4));
    } on TimeoutException catch (_) {
      errorMessage = 'Failed to connect';
      return false;
    }
    if (!signUpSuccess || _authService.getCurrentUserId() == null) {
      errorMessage = _authService.exception;
      return false;
    }
    final String? minimumVersion = await getMinimumAppVersion();
    if (minimumVersion != null) {
      if (versionToNumber(minimumVersion) > versionToNumber(_version)) {
        controller.add(AppScreenState.forceUpgrade);
        return true;
      }
    }
    final bool fetchUserSuccess = await _userRepository.fetchCurrentUser();
    if (fetchUserSuccess) {
      return false;
    }
    await fetchRepositoryData();
    controller.add(AppScreenState.setup);
    currentAppScreenState = AppScreenState.setup;
    return true;
  }

  Future<bool> attemptSignInWithEmail(String email, String password) async {
    bool signInSuccess = false;
    print('attempting signin');
    try {
      signInSuccess = await _authService
          .signInWithEmail(email, password)
          .timeout(const Duration(seconds: 4));
    } on TimeoutException catch (_) {
      errorMessage = 'Failed to connect';
      return false;
    }
    if (!signInSuccess || _authService.getCurrentUserId() == null) {
      errorMessage = _authService.exception;
      return false;
    }
    final String? minimumVersion = await getMinimumAppVersion();
    if (minimumVersion != null) {
      if (versionToNumber(minimumVersion) > versionToNumber(_version)) {
        controller.add(AppScreenState.forceUpgrade);
        return true;
      }
    }
    await fetchRepositoryData();
    controller.add(AppScreenState.loggedIn);
    currentAppScreenState = AppScreenState.loggedIn;
    return true;
  }

  Future<bool> setupNewUser(String username, String displayName,
      {int? pdgaNumber}) async {
    final MyPuttUser? newUser = await _authService
        .setupNewUser(username, displayName, pdgaNumber: pdgaNumber);
    if (await _authService.userIsSetup() && newUser != null) {
      _userRepository.currentUser = newUser;
      controller.add(AppScreenState.loggedIn);
      currentAppScreenState = AppScreenState.loggedIn;
      return true;
    } else {
      return false;
    }
  }

  void signOut() {
    clearRepositoryData();
    _authService.logOut();
    controller.add(AppScreenState.notLoggedIn);
    currentAppScreenState = AppScreenState.notLoggedIn;
  }
}
