import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/data/types/sessions/putting_session.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/screens/share/components/user_list_item.dart';
import 'package:myputt/utils/enums.dart';

import 'dialogs/send_challenge_dialog.dart';

class UserListView extends StatelessWidget {
  const UserListView(
      {Key? key, required this.session, required this.onComplete, this.preset})
      : super(key: key);

  final PuttingSession? session;
  final Function onComplete;
  final ChallengePreset? preset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserCubit, SearchUsersState>(
      builder: (context, state) {
        if (state is SearchUsersLoaded) {
          return ListView(
            children: state.users
                .map((user) => UserListItem(
                    onTap: () {
                      Vibrate.feedback(FeedbackType.light);
                      showDialog(
                          context: context,
                          builder: (context) => SendChallengeDialog(
                              preset: preset,
                              onComplete: onComplete,
                              recipientUser: user,
                              session: session));
                    },
                    user: user,
                    session: session))
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
