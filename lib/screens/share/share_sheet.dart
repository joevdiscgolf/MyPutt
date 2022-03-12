import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/utils/colors.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:share/share.dart';

import 'components/user_list_view.dart';

enum LoadingState { static, loading, loaded }

class ShareSheet extends StatefulWidget {
  const ShareSheet({Key? key, required this.session}) : super(key: key);

  final PuttingSession session;

  @override
  _ShareSheetState createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  final TextEditingController _searchTextController = TextEditingController();

  int lastUpdated = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      )),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => _share(),
                icon: const Icon(
                  FlutterRemix.link,
                  color: MyPuttColors.lightBlue,
                )),
          ],
          automaticallyImplyLeading: false,
          title: Text(
            'Send Challenge',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.grey[800]!),
          ),
          backgroundColor: Colors.grey[100]!,
          shadowColor: Colors.transparent,
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  'Search by username',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                _usernameField(context),
                Expanded(child: UserListView(session: widget.session))
              ],
            )),
      ),
    );
  }

  Widget _usernameField(BuildContext context) {
    return TextFormField(
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
        contentPadding:
            const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
        isDense: true,
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: TWUIColors.gray[400], fontSize: 18),
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.border,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: const Icon(
            FlutterRemix.user_line,
            color: TWUIColors.gray,
            size: 22,
          ),
        ),
        counter: const Offstage(),
      ),
      onChanged: (String username) async {
        if (DateTime.now().millisecondsSinceEpoch - lastUpdated > 200) {}
        setState(() {
          lastUpdated = DateTime.now().millisecondsSinceEpoch;
        });
        await BlocProvider.of<SearchUserCubit>(context)
            .searchUsersByUsername(username.toLowerCase());
      },
    );
  }

  Future<void> _share() async {
    final String? shareMessage = await BlocProvider.of<ChallengesCubit>(context)
        .getShareMessageFromSession(widget.session);
    if (shareMessage == null) {
      return;
    }
    await Share.share(
      shareMessage,
    );
  }
}
