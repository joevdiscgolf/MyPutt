import 'package:myputt/models/data/users/myputt_user.dart';

bool userIsValid(MyPuttUser? user) {
  return user?.username != null && user?.displayName != null;
}
