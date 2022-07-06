import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/pdga_player_info.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/services/web_scraper.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';

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
    if (_userRepository.currentUser == null) {
      await _userRepository.fetchCurrentUser();
      if (_userRepository.currentUser == null) {
        emit(NoProfileLoaded());
        return;
      }
    }

    PDGAPlayerInfo? playerInfo;
    try {
      playerInfo = await _webScraperService
          .getPDGAData(_userRepository.currentUser?.pdgaNum)
          .timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
    }
    if (playerInfo?.rating != null &&
        playerInfo?.rating != _userRepository.currentUser!.pdgaRating) {
      updateUserPDGARating(playerInfo!.rating!);
    }
    emit(
      MyProfileLoaded(
        myUser: _userRepository.currentUser!,
        pdgaPlayerInfo: playerInfo,
      ),
    );
  }

  Future<void> updateFrisbeeAvatar(FrisbeeAvatar frisbeeAvatar) async {
    _userRepository.updateUserAvatar(frisbeeAvatar);
    final PDGAPlayerInfo? playerInfo = await _webScraperService
        .getPDGAData(_userRepository.currentUser?.pdgaNum);
    emit(
      MyProfileLoaded(
        myUser: _userRepository.currentUser!,
        pdgaPlayerInfo: playerInfo,
      ),
    );
  }

  Future<bool> submitPDGANumber(String pdgaNum) async {
    if (int.tryParse(pdgaNum) != null) {
      final MyPuttUser? currentUser = _userRepository.currentUser;
      if (currentUser != null) {
        _userRepository.currentUser?.pdgaNum = int.parse(pdgaNum);
        final bool setUserSuccess =
            await _userService.setUserWithPayload(currentUser);
        if (setUserSuccess) {
          emit(
            MyProfileLoaded(
              myUser: _userRepository.currentUser!,
              pdgaPlayerInfo: await _webScraperService
                  .getPDGAData(_userRepository.currentUser?.pdgaNum),
            ),
          );
        }
        return setUserSuccess;
      }
    }
    return false;
  }

  void updateUserPDGARating(int rating) {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return;
    }
    _userRepository.currentUser = MyPuttUser(
        username: currentUser.username,
        keywords: currentUser.keywords,
        displayName: currentUser.displayName,
        uid: currentUser.uid,
        pdgaNum: currentUser.pdgaNum,
        pdgaRating: rating);
    _userService.setUserWithPayload(currentUser);
  }
}
