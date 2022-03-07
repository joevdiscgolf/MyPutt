import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/components/buttons/primary_button.dart';
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Challenge a friend',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              backgroundColor: Colors.transparent,
              labelColor: Colors.blue,
              width: double.infinity,
              label: 'Share with link',
              onPressed: () => _share(),
              iconColor: Colors.blue,
              icon: FlutterRemix.share_box_line,
            ),
            const SizedBox(height: 15),
            Text(
              'Find a MyPutt user',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            _usernameField(context),
            Expanded(child: UserListView(session: widget.session))
          ],
        ));
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
            const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
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
    final MyPuttUser? currentUser = locator.get<UserRepository>().currentUser;
    if (currentUser != null) {
      final StoragePuttingChallenge newChallenge =
          StoragePuttingChallenge.fromSession(widget.session, currentUser);
      await locator.get<DatabaseService>().setUnclaimedChallenge(newChallenge);
      final Uri uri = await locator
          .get<DynamicLinkService>()
          .generateDynamicLinkFromId(newChallenge.id);
      await Share.share(
        "${currentUser.displayName} thinks they can beat you in a putting challenge. Let's find out!\n${uri.toString()}",
      );
    }
  }
}
