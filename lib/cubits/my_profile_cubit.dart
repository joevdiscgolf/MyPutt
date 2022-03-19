import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/users/frisbee_avatar.dart';
import 'package:myputt/data/types/users/pdga_player_info.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/services/web_scraper.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/locator.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final WebScraperService _webScraperService = locator.get<WebScraperService>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  final UserService _userService = locator.get<UserService>();
  MyProfileCubit() : super(MyProfileInitial()) {
    reload();
  }

  void signOut() {
    emit(MyProfileInitial());
  }

  Future<void> reload() async {
    if (_userRepository.currentUser != null) {
      final PDGAPlayerInfo? playerInfo = await _webScraperService
          .getPDGAData(_userRepository.currentUser?.pdgaNum);
      emit(MyProfileLoaded(
          myUser: _userRepository.currentUser!, pdgaPlayerInfo: playerInfo));
    } else {
      emit(NoProfileLoaded());
    }
  }

  Future<void> updateFrisbeeAvatar(FrisbeeAvatar frisbeeAvatar) async {
    _userRepository.updateUserAvatar(frisbeeAvatar);
    final PDGAPlayerInfo? playerInfo = await _webScraperService
        .getPDGAData(_userRepository.currentUser?.pdgaNum);
    emit(MyProfileLoaded(
        myUser: _userRepository.currentUser!, pdgaPlayerInfo: playerInfo));
  }

  Future<bool> submitPDGANumber(String pdgaNum) async {
    if (int.tryParse(pdgaNum) != null) {
      final MyPuttUser? currentUser = _userRepository.currentUser;
      if (currentUser != null) {
        _userRepository.currentUser?.pdgaNum = int.parse(pdgaNum);
        final bool setUserSuccess =
            await _userService.setUserWithPayload(currentUser);
        if (setUserSuccess) {
          emit(MyProfileLoaded(
              myUser: _userRepository.currentUser!,
              pdgaPlayerInfo: await _webScraperService
                  .getPDGAData(_userRepository.currentUser?.pdgaNum)));
        }
        return setUserSuccess;
      }
    }
    return false;
  }
}
