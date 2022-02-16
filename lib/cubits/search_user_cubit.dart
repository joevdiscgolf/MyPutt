import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';

import '../locator.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUsersState> {
  final UserRepository _userRepository = locator.get<UserRepository>();
  SearchUserCubit() : super(SearchUsersInitial());

  Future<void> searchUsersByUsername(String username) async {
    emit(SearchUsersLoading());
    final List<MyPuttUser> users =
        await _userRepository.fetchUsersByUsername(username);
    emit(SearchUsersLoaded(users: users));
  }
}
