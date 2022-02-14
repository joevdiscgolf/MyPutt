import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/repositories/user_repository.dart';

import '../data/types/myputt_user.dart';
import '../locator.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepository _userRepository = locator.get<UserRepository>();
  MyProfileCubit() : super(MyProfileInitial()) {
    reload();
  }

  void reload() {
    if (_userRepository.currentUser != null) {
      emit(MyProfileLoaded(myUser: _userRepository.currentUser!));
    } else {
      emit(NoProfileLoaded());
    }
  }
}
