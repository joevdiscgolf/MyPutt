import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'buttons/primary_button.dart';

enum LoadingState { static, loading, loaded }

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
                if (DateTime.now().millisecondsSinceEpoch - lastUpdated >
                    200) {}
                setState(() {
                  lastUpdated = DateTime.now().millisecondsSinceEpoch;
                });
                await BlocProvider.of<SearchUserCubit>(context)
                    .searchUsersByUsername(username);
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

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.user, required this.session})
      : super(key: key);

  final PuttingSession session;
  final MyPuttUser user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                SendChallengeDialog(recipientUser: user, session: session));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[400]!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Flexible(
              flex: 1,
              child: DefaultProfileCircle(),
            ),
            Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Username',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(user.username),
                  ],
                )),
            Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Display name',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(user.displayName),
                  ],
                )),
            const Flexible(
                flex: 2, child: Icon(FlutterRemix.arrow_right_s_line))
          ],
        ),
      ),
    );
  }
}

class DefaultProfileCircle extends StatelessWidget {
  const DefaultProfileCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(color: Colors.grey[300]!, shape: BoxShape.circle),
      child:
          Center(child: Icon(FlutterRemix.user_fill, color: Colors.grey[600]!)),
    );
  }
}

class SendChallengeDialog extends StatefulWidget {
  const SendChallengeDialog(
      {Key? key, required this.recipientUser, required this.session})
      : super(key: key);

  final MyPuttUser recipientUser;
  final PuttingSession session;

  @override
  _SendChallengeDialogState createState() => _SendChallengeDialogState();
}

class _SendChallengeDialogState extends State<SendChallengeDialog> {
  String? _dialogErrorText;
  LoadingState _loadingState = LoadingState.static;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: _mainBody(context)));
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const Text(
                'Send challenge to',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                ' ${widget.recipientUser.displayName}',
                style: TextStyle(
                    color: ThemeColors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(_dialogErrorText ?? ''),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryButton(
                    width: 100,
                    height: 50,
                    label: 'Cancel',
                    fontSize: 18,
                    labelColor: Colors.grey[600]!,
                    backgroundColor: Colors.grey[200]!,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ThemeColors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48)),
                        enableFeedback: true,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        onPrimary: Colors.grey[100],
                      ),
                      onPressed: () async {
                        setState(() {
                          _loadingState = LoadingState.loading;
                        });

                        await BlocProvider.of<ChallengesCubit>(context)
                            .sendChallenge(
                                widget.session, widget.recipientUser);
                        setState(() {
                          _loadingState = LoadingState.loaded;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                      },
                      child: Builder(builder: (context) {
                        switch (_loadingState) {
                          case LoadingState.static:
                            return Text('Send');
                          case LoadingState.loading:
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          case LoadingState.loaded:
                            return const Icon(
                              FlutterRemix.check_line,
                              color: Colors.white,
                            );
                        }
                        return Text('Send');
                      })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
