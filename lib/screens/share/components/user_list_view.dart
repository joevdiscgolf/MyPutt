import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/screens/share/components/user_list_item.dart';

class UserListView extends StatefulWidget {
  const UserListView({Key? key, required this.session}) : super(key: key);

  final PuttingSession session;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserCubit, SearchUsersState>(
      builder: (context, state) {
        if (state is SearchUsersLoaded) {
          return ListView(
            children: state.users
                .map(
                    (user) => UserListItem(user: user, session: widget.session))
                .toList(),
          );
        } else if (state is SearchUsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
  }
}
