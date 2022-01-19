import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/record_putting/cubits/sessions_screen_cubit.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';

class FinishSessionDialog extends StatefulWidget {
  const FinishSessionDialog({Key? key}) : super(key: key);

  @override
  _FinishSessionDialogState createState() => _FinishSessionDialogState();
}

class _FinishSessionDialogState extends State<FinishSessionDialog> {
  String? _dialogErrorText;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Finish Putting Session',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
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
                          setState(() {
                            _dialogErrorText = '';
                          });
                          BlocProvider.of<SessionsScreenCubit>(context)
                              .continueSession();
                          Navigator.pop(context);
                          return 'Cancel';
                        }),
                    BlocBuilder<SessionsScreenCubit, SessionsScreenState>(
                      builder: (context, state) {
                        if (state is SessionInProgressState) {
                          return PrimaryButton(
                            label: 'Finish',
                            fontSize: 18,
                            width: 100,
                            height: 50,
                            backgroundColor: Colors.green,
                            onPressed: () {
                              final List<PuttingSet>? sets =
                                  state.currentSession.sets;
                              if (sets == null || sets.isEmpty) {
                                setState(() {
                                  _dialogErrorText = 'Empty session!';
                                });
                              } else {
                                BlocProvider.of<SessionsScreenCubit>(context)
                                    .completeSession();
                                Navigator.pop(context);
                              }
                              return 'Finish';
                            },
                          );
                        } else {
                          return PrimaryButton(
                              label: 'Finish',
                              fontSize: 18,
                              width: 100,
                              height: 50,
                              backgroundColor: Colors.green,
                              onPressed: () {
                                setState(() {
                                  _dialogErrorText = "No ongoing session";
                                });
                                return 'Finish';
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
