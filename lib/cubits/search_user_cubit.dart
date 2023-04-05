import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUsersState> implements MyPuttCubit {
  @override
  void initCubit() {
    // TODO: implement init
  }

  final UserRepository _userRepository = locator.get<UserRepository>();
  SearchUserCubit() : super(SearchUsersInitial());

  Future<void> searchUsersByUsername(String username) async {
    emit(SearchUsersLoading());
    final List<MyPuttUser> users =
        await _userRepository.fetchUsersByUsername(username);
    emit(SearchUsersLoaded(users: users));
  }
}
