import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/confirm_dialog.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import '../cubits/challenges_cubit.dart';

class SearchUsersSheet extends StatefulWidget {
  const SearchUsersSheet({Key? key, required this.session}) : super(key: key);

  final PuttingSession session;

  @override
  _SearchUsersSheetState createState() => _SearchUsersSheetState();
}

class _SearchUsersSheetState extends State<SearchUsersSheet> {
  final TextEditingController _searchTextController = TextEditingController();

  int lastUpdated = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Challenge a friend',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextFormField(
              controller: _searchTextController,
              autocorrect: false,
              maxLines: 1,
              maxLength: 24,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter username',
                contentPadding: const EdgeInsets.only(
                    left: 12, right: 12, top: 18, bottom: 18),
                isDense: true,
                hintStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: TWUIColors.gray[400], fontSize: 18),
                enabledBorder: Theme.of(context).inputDecorationTheme.border,
                focusedBorder: Theme.of(context).inputDecorationTheme.border,
                prefixIcon: const Icon(
                  FlutterRemix.user_line,
                  color: TWUIColors.gray,
                  size: 22,
                ),
                counter: const Offstage(),
              ),
              onChanged: (String username) async {
                if (DateTime.now().millisecondsSinceEpoch - lastUpdated > 200) {
                  await BlocProvider.of<SearchUserCubit>(context)
                      .searchUsersByUsername(username);
                }
                setState(() {
                  lastUpdated = DateTime.now().millisecondsSinceEpoch;
                });
              },
            ),
            Expanded(child: UserListView(session: widget.session))
          ],
        ));
  }
}

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
        print('updated and rebuilding, state: $state');
        if (state is SearchUsersLoaded) {
          for (var user in state.users) {
            print(user.toJson());
          }
          return ListView(
            children: state.users
                .map(
                    (user) => UserListItem(user: user, session: widget.session))
                .toList(),
          );
        } else if (state is SearchUsersLoading) {
          return Center(child: const CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
  }
}

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.user, required this.session})
      : super(key: key);

  final PuttingSession session;
  final MyPuttUser user;

  @override
  Widget build(BuildContext context) {
    print(user.toJson());
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
                actionPressed: () {
                  BlocProvider.of<ChallengesCubit>(context)
                      .sendChallenge(session);
                },
                title: 'Send challenge',
                confirmColor: ThemeColors.green,
                buttonlabel: 'Send'));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[400]!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text(user.displayName), Text(user.username)],
        ),
      ),
    );
  }
}
