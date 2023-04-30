import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/protocols/repository.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/services/firebase/user_data_writer.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/flags.dart';

class UserRepository extends ChangeNotifier
    implements SingletonConsumer, MyPuttRepository {
  @override
  void initSingletons() {
    _authService = locator.get<FirebaseAuthService>();
    _localDBService = locator.get<LocalDBService>();
  }

  @override
  void clearData() {
    currentUser = null;
  }

  MyPuttUser? _currentUser;
  MyPuttUser? get currentUser => _currentUser;

  set currentUser(MyPuttUser? currentUser) {
    _currentUser = currentUser;
    _saveCurrentUserInLocalDb();
    notifyListeners();
  }

  late final FirebaseAuthService _authService;
  late final LocalDBService _localDBService;

  bool fetchLocalCurrentUser() {
    final MyPuttUser? localCurrentUser = _localDBService.fetchCurrentUser();
    _log(
      '[fetchLocalCurrentUser] Fetched local current user: $localCurrentUser',
    );
    if (localCurrentUser == null) {
      return false;
    }

    _currentUser = localCurrentUser;
    return true;
  }

  Future<bool> fetchCloudCurrentUser({
    Duration timeoutDuration = shortTimeout,
  }) async {
    if (_authService.getCurrentUserId() == null) {
      _log('[fetchCloudCurrentUser] Auth service current uid == null');
      return false;
    } else {
      final MyPuttUser? cloudCurrentUser =
          await FBUserDataLoader.instance.getCurrentUser(
        timeoutDuration: timeoutDuration,
      );

      if (cloudCurrentUser == null) return false;

      if (cloudCurrentUser != _currentUser) {
        currentUser = cloudCurrentUser;
        _saveCurrentUserInLocalDb();
      }

      return true;
    }
  }

  Future<bool> updateUserAvatar(FrisbeeAvatar frisbeeAvatar) async {
    if (currentUser == null) return false;
    currentUser = currentUser!.copyWith(frisbeeAvatar: frisbeeAvatar);
    return FBUserDataWriter.instance.updateUserWithPayload(
      currentUser!.uid,
      {'frisbeeAvatar': frisbeeAvatar.toJson()},
    );
  }

  Future<bool> _saveCurrentUserInLocalDb() async {
    if (currentUser == null) {
      return false;
    }
    final bool localSaveSuccess =
        await _localDBService.saveCurrentUser(currentUser!);

    _log('[_saveCurrentUserInLocalDb] local save success: $localSaveSuccess');
    return localSaveSuccess;
  }

  void _log(String message) {
    if (Flags.kUserRepositoryLogs) {
      log('[UserRepository] $message');
    }
  }
}
