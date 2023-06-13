import 'dart:async';
import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/cubits/app_phase_cubit.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/user_helpers.dart';
import 'package:myputt/utils/utils.dart';

class MyPuttAuthService {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  final FirebaseAuthService _firebaseAuthService =
      locator.get<FirebaseAuthService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  String errorMessage = '';

  Future<bool> deleteCurrentUser() {
    return _firebaseAuthService.deleteCurrentUser().then((success) {
      if (success) {
        locator.get<SharedPreferencesService>().markUserIsSetUp(false);
        locator.get<AppPhaseCubit>().emitState(const LoggedOutPhase());
      }
      return success;
    });
  }

  Future<bool> attemptSignUpWithEmail(String email, String password) async {
    bool signUpSuccess = false;
    try {
      signUpSuccess = await _firebaseAuthService
          .signUpWithEmail(email, password)
          .timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      errorMessage = 'Failed to connect';
      signUpSuccess = false;
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[MyPuttAuthService][attemptSignUpWithEmail] authService.signUpWithEmail timeout',
      );
    }

    if (!signUpSuccess || _firebaseAuthService.getCurrentUserId() == null) {
      errorMessage = _firebaseAuthService.exception;
      return false;
    } else {
      locator.get<AppPhaseCubit>().emitState(const SetUpPhase());
      return true;
    }
  }

  Future<bool> attemptSignInWithEmail(String email, String password) async {
    bool signInSuccess = false;
    try {
      signInSuccess = await _firebaseAuthService
          .signInWithEmail(email, password)
          .timeout(shortTimeout);
    } on Exception catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      errorMessage = 'Failed to connect';
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[MyPuttAuthService][attemptSignInWithEmail] authService.signInWithEmail timeout',
      );
      return false;
    }

    if (!signInSuccess || _firebaseAuthService.getCurrentUserId() == null) {
      errorMessage = _firebaseAuthService.exception;
      return false;
    }

    bool? isSetup;

    await FBUserDataLoader.instance.getCurrentUser().then(
      (MyPuttUser? user) {
        isSetup = userIsValid(user);
      },
    ).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AuthService][userIsSetup] get User timeout',
      );
    });

    if (isSetup == null) {
      errorMessage = 'Something went wrong, please try again.';
      return false;
    } else if (isSetup == false) {
      locator.get<AppPhaseCubit>().emitState(const SetUpPhase());
      return true;
    }

    // mark is set up to true
    locator.get<SharedPreferencesService>().markUserIsSetUp(true);

    _mixpanel.track(
      'Sign in',
      properties: {'Uid': _firebaseAuthService.getCurrentUserId()},
    );

    try {
      fetchLocalRepositoryData();
      fetchRepositoryData();
      locator.get<AppPhaseCubit>().emitState(const LoggedInPhase());
    } catch (e, trace) {
      log('[myputt_auth_service][attemptSigninWithEmail] Failed to fetch repository data. Error: $e');
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[MyPuttAuthService][attemptSignInWithEmail] fetchRepositoryData timeout',
      );
    }

    return true;
  }

  Future<bool> setupNewUser(
    String username,
    String displayName, {
    int? pdgaNumber,
  }) async {
    final MyPuttUser? newUser = await _firebaseAuthService
        .setupNewUser(username, displayName, pdgaNumber: pdgaNumber);
    if (newUser == null) {
      return false;
    }
    bool? isSetUp;

    await FBUserDataLoader.instance.getCurrentUser().then(
      (MyPuttUser? user) {
        isSetUp = userIsValid(user);
      },
    ).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AuthService][userIsSetup] get User timeout',
      );
    });

    if (isSetUp != true) {
      return false;
    }

    _mixpanel.track(
      'New User Set Up',
      properties: {'Uid': newUser.uid, 'Username': username},
    );

    _userRepository.currentUser = newUser;
    locator.get<AppPhaseCubit>().emitState(const LoggedInPhase());
    return true;
  }

  void signOut() {
    _mixpanel.track(
      'Log out',
      properties: {'Uid': _firebaseAuthService.getCurrentUserId()},
    );
    clearRepositoryData();
    locator.get<SharedPreferencesService>().markUserIsSetUp(false);
    _firebaseAuthService.logOut();
    locator.get<AppPhaseCubit>().emitState(const LoggedOutPhase());
  }
}
