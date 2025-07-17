import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/pdga_player_info.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase/user_data_writer.dart';
import 'package:myputt/services/web_scraper.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> implements MyPuttCubit {
  @override
  void initCubit() {
    // todo: implement init
  }

  final WebScraperService _webScraperService = locator.get<WebScraperService>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  MyProfileCubit() : super(MyProfileInitial());

  void signOut() {
    emit(MyProfileInitial());
  }

  Future<void> reload() async {
    if (_userRepository.currentUser != null) {
      emit(
        MyProfileLoaded(
          myUser: _userRepository.currentUser!,
          pdgaPlayerInfo: null,
        ),
      );
    } else {
      await _userRepository.fetchCloudCurrentUser();
      if (_userRepository.currentUser == null) {
        emit(NoProfileLoaded());
        return;
      }
    }

    PDGAPlayerInfo? playerInfo;
    try {
      playerInfo = await _webScraperService
          .getPDGAData(_userRepository.currentUser?.pdgaNum)
          .timeout(standardTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[MyProfileCubit][reload] webScraperService.getPDGAData() timeout',
      );
    }

    if (_userRepository.currentUser == null) {
      emit(NoProfileLoaded());
    } else {
      if (playerInfo?.rating != null &&
          playerInfo?.rating != _userRepository.currentUser?.pdgaRating) {
        updateUserPDGARating(playerInfo!.rating!);
      }
      emit(
        MyProfileLoaded(
          myUser: _userRepository.currentUser!,
          pdgaPlayerInfo: playerInfo,
        ),
      );
    }
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
        _userRepository.currentUser = _userRepository.currentUser?.copyWith(
          pdgaNum: int.parse(pdgaNum),
        );
        final bool updateUserSuccess =
            await FBUserDataWriter.instance.updateUserWithPayload(
          currentUser.uid,
          {'pdgaNum': int.parse(pdgaNum)},
        );
        if (updateUserSuccess) {
          final PDGAPlayerInfo? playerInfo = await _webScraperService
              .getPDGAData(_userRepository.currentUser?.pdgaNum);
          emit(
            MyProfileLoaded(
              myUser: _userRepository.currentUser!,
              pdgaPlayerInfo: playerInfo,
            ),
          );
        }
        return updateUserSuccess;
      }
    }
    return false;
  }

  void updateUserPDGARating(int rating) {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return;
    }
    _userRepository.currentUser =
        _userRepository.currentUser?.copyWith(pdgaRating: rating);

    FBUserDataWriter.instance.updateUserWithPayload(
      currentUser.uid,
      {'pdgaRating': rating},
    );
  }
}
