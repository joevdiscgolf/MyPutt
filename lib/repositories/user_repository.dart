import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';

class UserRepository {
  MyPuttUser? currentUser;
  final AuthService _authService = locator.get<AuthService>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();

  void setCurrentUser(MyPuttUser newUser) {
    currentUser = newUser;
  }

  Future<bool> fetchCurrentUser() async {
    if (_authService.getCurrentUserId() == null) {
      return false;
    } else {
      currentUser = await _databaseService.getCurrentUser();
      print('User | ${currentUser?.toJson()}');
      return currentUser != null;
    }
  }
}
