import 'package:myputt/locator.dart';
import 'package:myputt/services/auth_service.dart';

const kAdminUids = ['BnisFzLsy0PnJuXv26BQ86HTVJk2'];

final AuthService _authService = locator.get<AuthService>();

bool isAdminAccount() {
  final String? currentUid = _authService.getCurrentUserId();
  if (currentUid == null) {
    return false;
  }
  return kAdminUids.contains(currentUid);
}
