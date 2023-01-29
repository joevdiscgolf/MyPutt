import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/firebase/app_info_data_loader.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'package:myputt/utils/user_helpers.dart';
import 'package:myputt/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_phase_state.dart';

class AppPhaseCubit extends Cubit<AppPhaseState> {
  AppPhaseCubit() : super(const AppPhaseInitial());

  Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;

    final String? minimumVersion =
        await FBAppInfoDataLoader.instance.getMinimumAppVersion();

    if (minimumVersion != null &&
        versionToNumber(minimumVersion) > versionToNumber(version)) {
      emit(const ForceUpgradePhase());
      return;
    }

    if (locator.get<FirebaseAuthService>().getCurrentUserId() == null) {
      emit(const LoggedOutPhase());
      return;
    }

    bool? userSetUpInCloud;

    await FBUserDataLoader.instance.getUser().then((MyPuttUser? user) {
      userSetUpInCloud = userIsValid(user);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AuthService][userIsSetup] get User timeout',
      );
    });

    if (userSetUpInCloud == true) {
      await locator.get<SharedPreferencesService>().markUserIsSetUp(true);
    } else {
      final bool? isSetUpLocal =
          await locator.get<SharedPreferencesService>().userIsSetUp();
      if (isSetUpLocal == null) {
        emit(const ConnectionErrorPhase());
        return;
      } else if (!isSetUpLocal) {
        emit(const SetUpPhase());
        return;
      }
    }

    fetchLocalRepositoryData();
    await fetchRepositoryData();

    emit(const LoggedInPhase());
  }

  void emitState(AppPhaseState appPhaseState) {
    emit(appPhaseState);
  }
}
