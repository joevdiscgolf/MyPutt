import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/services/firebase/user_data_writer.dart';

class UserService {
  final FBUserDataWriter _userDataWriter = FBUserDataWriter();

  Future<bool> setUserWithPayload(MyPuttUser user) {
    return _userDataWriter.setUserWithPayload(user);
  }
}
