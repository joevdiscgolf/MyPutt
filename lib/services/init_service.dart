import 'dart:async';

import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'auth_service.dart';
import 'firebase/app_info_data_loader.dart';

class InitService {
  final AuthService _authService = locator.get<AuthService>();

  final ScreenController _screenController = locator.get<ScreenController>();
  late StreamController<AppScreenState> controller;
  late Stream<AppScreenState> siginStream;

  InitService() {
    controller = _screenController.controller;
  }

  Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    if (_authService.getCurrentUserId() != null) {
      bool failedToConnect = false;
      bool isSetup = false;
      try {
        isSetup = await _authService.userIsSetup().timeout(
            const Duration(seconds: 2),
            onTimeout: () => failedToConnect = true);
      } catch (e) {
        return;
      }
      if (failedToConnect) {
        controller.add(AppScreenState.connectionError);
      } else {
        if (!isSetup) {
          controller.add(AppScreenState.setup);
          return;
        }
        final String? minimumVersion =
            await getMinimumAppVersion().timeout(const Duration(seconds: 2));
        if (minimumVersion == null) {
          controller.add(AppScreenState.loggedIn);
          return;
        }
        if (versionToNumber(minimumVersion) > versionToNumber(version)) {
          controller.add(AppScreenState.forceUpgrade);
          return;
        }
        await fetchRepositoryData().timeout(const Duration(seconds: 2));
        controller.add(AppScreenState.loggedIn);
      }
    } else {
      controller.add(AppScreenState.notLoggedIn);
    }
  }
}
