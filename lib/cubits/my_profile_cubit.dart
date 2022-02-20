import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/pdga_player_info.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/web_scraper.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/locator.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final WebScraperService _webScraperService = locator.get<WebScraperService>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  MyProfileCubit() : super(MyProfileInitial()) {
    reload();
  }

  Future<void> reload() async {
    if (_userRepository.currentUser != null) {
      PDGAPlayerInfo? playerInfo;
      if (_userRepository.currentUser?.pdgaNum != null) {
        playerInfo = await _webScraperService
            .getPDGAData(_userRepository.currentUser!.pdgaNum!);
      }
      emit(MyProfileLoaded(
          myUser: _userRepository.currentUser!, pdgaPlayerInfo: playerInfo));
    } else {
      emit(NoProfileLoaded());
    }
  }
}
