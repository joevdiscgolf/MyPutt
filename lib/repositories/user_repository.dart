import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/user_service.dart';

class UserRepository {
  MyPuttUser? currentUser;
  final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final UserService _userService = locator.get<UserService>();

  void clearData() {
    currentUser = null;
  }

  void setCurrentUser(MyPuttUser newUser) {
    currentUser = newUser;
  }

  Future<bool> fetchCurrentUser() async {
    if (_authService.getCurrentUserId() == null) {
      return false;
    } else {
      currentUser = await _databaseService.getCurrentUser();
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
