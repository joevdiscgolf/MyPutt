import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_auth_service.dart';
import 'firebase/app_info_data_loader.dart';

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

    final String? minimumVersion = await getMinimumAppVersion();

    if (minimumVersion == null) {
      controller.add(AppScreenState.connectionError);
      return;
    }
    if (versionToNumber(minimumVersion) > versionToNumber(version)) {
      controller.add(AppScreenState.forceUpgrade);
      return;
    } else if (_authService.getCurrentUserId() == null) {
      controller.add(AppScreenState.notLoggedIn);
      return;
    }

    final bool? isSetup = await _authService.userIsSetup();
    if (isSetup == null) {
      controller.add(AppScreenState.connectionError);
      return;
    } else if (!isSetup) {
      controller.add(AppScreenState.setup);
      return;
    }

    try {
      await fetchRepositoryData().timeout(standardTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      controller.add(AppScreenState.connectionError);
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[InitManager][init] fetchRepositoryData timeout',
      );
      return;
    }
    controller.add(AppScreenState.loggedIn);
  }
}
