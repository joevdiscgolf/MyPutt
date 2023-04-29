import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/screens/share/share_sheet.dart';
import 'package:myputt/utils/enums.dart';

class SendChallengeDialog extends StatefulWidget {
  const SendChallengeDialog(
      {Key? key,
      required this.recipientUser,
      this.session,
      required this.onComplete,
      this.preset})
      : super(key: key);

  final MyPuttUser recipientUser;
  final PuttingSession? session;
  final Function onComplete;
  final ChallengePreset? preset;

  @override
  _SendChallengeDialogState createState() => _SendChallengeDialogState();
}

class _SendChallengeDialogState extends State<SendChallengeDialog> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();

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
        child: _mainBody(context),
      ),
    );
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
          AutoSizeText(
            'Send challenge',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          AutoSizeText(
            widget.recipientUser.displayName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.blue, fontSize: 20),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          const ShadowIcon(
              icon: Icon(
            FlutterRemix.sword_fill,
            color: MyPuttColors.black,
            size: 80,
          )),
          const SizedBox(height: 8),
          if (_dialogErrorText != null)
            Text(
              _dialogErrorText!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: MyPuttColors.red, fontSize: 12),
            ),
          const SizedBox(height: 8),
          MyPuttButton(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            title: 'Send',
            textSize: 18,
            height: 40,
            borderColor: MyPuttColors.blue,
            backgroundColor: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: _sharePressed,
            buttonState: _loadingState == LoadingState.loading
                ? ButtonState.loading
                : ButtonState.normal,
          ),
          MyPuttButton(
              width: 100,
              height: 40,
              title: 'Cancel',
              textSize: 12,
              textColor: Colors.grey[600]!,
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void _sharePressed() async {
    if (widget.preset != null) {
      _shareChallenge(sendChallenge: () {
        return BlocProvider.of<ChallengesCubit>(context)
            .sendChallengeWithPreset(
          widget.preset!,
          widget.recipientUser,
        );
      }, logEvent: () {
        _mixpanel.track(
          'Send Challenge Dialog Share From Preset Pressed',
          properties: {
            'Recipient Uid': widget.recipientUser.uid,
            'Recipient Username': widget.recipientUser.username,
            'Preset': describeEnum(widget.preset!),
          },
        );
      });
    } else if (widget.session != null) {
      _shareChallenge(sendChallenge: () {
        return BlocProvider.of<ChallengesCubit>(context)
            .sendChallengeFromSession(
          widget.session!,
          widget.recipientUser,
        );
      }, logEvent: () {
        _mixpanel.track(
          'Send Challenge Dialog Share From Session Pressed',
          properties: {
            'Recipient Uid': widget.recipientUser.uid,
            'Recipient Username': widget.recipientUser.username,
          },
        );
      });
    }
  }

  Future<void> _shareChallenge({
    required Future<bool> Function() sendChallenge,
    required void Function() logEvent,
  }) async {
    setState(() {
      _loadingState = LoadingState.loading;
    });

    final bool sendSuccess = await sendChallenge();
    if (!sendSuccess) {
      setState(() {
        _loadingState = LoadingState.static;
      });
      return;
    }

    setState(() {
      _loadingState = LoadingState.loaded;
    });
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    widget.onComplete();
    Navigator.pop(context);
  }
}
