import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/database_service.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUsersState> implements MyPuttCubit {
  @override
  void initCubit() {
    // Implement init
  }

  final DatabaseService _databaseService = locator.get<DatabaseService>();
  SearchUserCubit() : super(SearchUsersInitial());

  Future<void> searchUsersByUsername(String username) async {
    emit(SearchUsersLoading());
    final List<MyPuttUser> users =
        await _databaseService.getUsersByUsername(username);
    emit(SearchUsersLoaded(users: users));
  }
}
