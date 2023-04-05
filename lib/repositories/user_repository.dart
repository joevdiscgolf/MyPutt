import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/protocols/repository.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/utils/constants.dart';

class UserRepository implements SingletonConsumer, MyPuttRepository {
  @override
  void initSingletons() {
    _authService = locator.get<FirebaseAuthService>();
    _databaseService = locator.get<DatabaseService>();
    _userService = locator.get<UserService>();
  }

  @override
  void clearData() {
    currentUser = null;
  }

  MyPuttUser? currentUser;
  late final FirebaseAuthService _authService;
  late final DatabaseService _databaseService;
  late final UserService _userService;

  Future<bool> fetchCurrentUser({
    Duration timeoutDuration = shortTimeout,
  }) async {
    if (_authService.getCurrentUserId() == null) {
      return false;
    } else {
      currentUser = await FBUserDataLoader.instance.getCurrentUser(
        timeoutDuration: timeoutDuration,
      );
      return currentUser != null;
    }
  }

  Future<List<MyPuttUser>> fetchUsersByUsername(String username) async {
    return _databaseService.getUsersByUsername(username);
  }

  Future<bool> updateUserAvatar(FrisbeeAvatar frisbeeAvatar) async {
    if (currentUser != null) {
      currentUser?.frisbeeAvatar = frisbeeAvatar;
      return _userService.setUserWithPayload(currentUser!);
    }
    return false;
  }
}
