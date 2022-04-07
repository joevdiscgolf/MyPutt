import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/sessions/putting_session.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
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
                style: const TextStyle(
                    color: MyPuttColors.green,
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
                        primary: MyPuttColors.green,
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

                        if (widget.preset != null) {
                          await BlocProvider.of<ChallengesCubit>(context)
                              .sendChallengeWithPreset(
                                  widget.preset!, widget.recipientUser);
                        } else if (widget.session != null) {
                          await BlocProvider.of<ChallengesCubit>(context)
                              .generateAndSendChallengeToUser(
                                  widget.session!, widget.recipientUser);
                        }
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          _loadingState = LoadingState.loaded;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          widget.onComplete();
                          Navigator.pop(context);
                        });
                      },
                      child: Builder(builder: (context) {
                        switch (_loadingState) {
                          case LoadingState.static:
                            return const Text('Send');
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
