import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/search_user_cubit.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';

import 'components/user_list_view.dart';

enum LoadingState { static, loading, loaded }

class ShareSheet extends StatefulWidget {
  const ShareSheet(
      {Key? key, this.session, required this.onComplete, this.preset})
      : super(key: key);

  final PuttingSession? session;
  final Function onComplete;
  final ChallengePreset? preset;

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  final TextEditingController _searchTextController = TextEditingController();

  int lastUpdated = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          color: MyPuttColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Send Challenge',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 32),
              ),
              const SizedBox(height: 8),
              const Icon(
                FlutterRemix.sword_fill,
                color: MyPuttColors.black,
                size: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _usernameField(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: UserListView(
            preset: widget.preset,
            onComplete: widget.onComplete,
            session: widget.session,
          ),
        ),
      ],
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
          .titleMedium!
          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Search by username',
        contentPadding:
            const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
        isDense: true,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: MyPuttColors.gray[300], fontSize: 18),
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.border,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Icon(
            FlutterRemix.user_line,
            color: MyPuttColors.gray[400]!,
            size: 22,
          ),
        ),
        counter: const Offstage(),
      ),
      onChanged: (String username) async {
        if (DateTime.now().millisecondsSinceEpoch - lastUpdated > 500) {}
        setState(() {
          lastUpdated = DateTime.now().millisecondsSinceEpoch;
        });
        await BlocProvider.of<SearchUserCubit>(context)
            .searchUsersByUsername(username.toLowerCase());
      },
    );
  }

  // Future<void> _shareWithLink() async {
  //   Vibrate.feedback(FeedbackType.light);
  //   _mixpanel.track('Share Challenge Screen Send Link Button Pressed');
  //   String? shareMessage;
  //   if (widget.preset != null) {
  //     shareMessage = await BlocProvider.of<ChallengesCubit>(context)
  //         .getShareMessageFromPreset(widget.preset!);
  //   }
  //   if (widget.session != null) {
  //     shareMessage = await BlocProvider.of<ChallengesCubit>(context)
  //         .getShareMessageFromSession(widget.session!);
  //   }
  //   if (shareMessage == null) {
  //     return;
  //   }
  //   await Share.share(
  //     shareMessage,
  //   );
  // }
}
