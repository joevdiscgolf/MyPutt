import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/app_info_service.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/utils/user_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_auth_service.dart';

class InitManager {
  final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();

  final ScreenController _screenController = locator.get<ScreenController>();
  late StreamController<AppScreenState> controller;
  late Stream<AppScreenState> siginStream;

  InitManager() {
    controller = _screenController.controller;
  }

  Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;

    late final String? minimumVersion;
    try {
      minimumVersion =
          await locator.get<AppInfoService>().getMinimumAppVersion();
    } catch (e, trace) {
      print('catching app verison error');
      log(e.toString());
      log(trace.toString());
      minimumVersion = null;
    }

    print('got past app version');

    if (minimumVersion != null &&
        versionToNumber(minimumVersion) > versionToNumber(version)) {
      controller.add(AppScreenState.forceUpgrade);
      return;
    } else if (_authService.getCurrentUserId() == null) {
      controller.add(AppScreenState.notLoggedIn);
      return;
    }

    bool? userSetUpInCloud;

    await locator.get<UserService>().getUser().then((MyPuttUser? user) {
      userSetUpInCloud = userIsValid(user);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AuthService][userIsSetup] get User timeout',
      );
    });

    print('got past user is set up check');
    if (userSetUpInCloud == true) {
      await locator.get<SharedPreferencesService>().markUserIsSetUp(true);
    }

    final bool? isSetUp =
        await locator.get<SharedPreferencesService>().userIsSetUp();
    if (isSetUp == null) {
      controller.add(AppScreenState.connectionError);
      return;
    } else if (!isSetUp) {
      controller.add(AppScreenState.setup);
      return;
    }

    try {
      print('got to this spot');
      fetchLocalRepositoryData();
      fetchRepositoryData().timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      // controller.add(AppScreenState.connectionError);
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[InitManager][init] fetchRepositoryData timeout',
      );
    }
    controller.add(AppScreenState.loggedIn);
  }
}
