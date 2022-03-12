import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/utils/colors.dart';

class FinishSessionDialog extends StatefulWidget {
  const FinishSessionDialog({Key? key, required this.stopSession})
      : super(key: key);

  final Function stopSession;

  @override
  State<FinishSessionDialog> createState() => _FinishSessionDialogState();
}

class _FinishSessionDialogState extends State<FinishSessionDialog> {
  String _dialogErrorText = '';

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
              Text(_dialogErrorText),
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
                        onPressed: () async {
                          _dialogErrorText = '';
                          Navigator.pop(context);
                        }),
                    BlocBuilder<SessionsCubit, SessionsState>(
                      builder: (context, state) {
                        if (state is SessionInProgressState) {
                          return PrimaryButton(
                            label: 'Finish',
                            fontSize: 18,
                            width: 100,
                            height: 50,
                            backgroundColor: MyPuttColors.green,
                            onPressed: () async {
                              final List<PuttingSet>? sets =
                                  state.currentSession.sets;
                              if (sets == null || sets.isEmpty) {
                                setState(() {
                                  _dialogErrorText = 'Empty session!';
                                });
                              } else {
                                await BlocProvider.of<SessionsCubit>(context)
                                    .completeSession();
                                widget.stopSession();
                                Navigator.pop(context);
                              }
                            },
                          );
                        } else {
                          return PrimaryButton(
                              label: 'Finish',
                              fontSize: 18,
                              width: 100,
                              height: 50,
                              backgroundColor: MyPuttColors.green,
                              onPressed: () {
                                setState(() {
                                  _dialogErrorText = "No active session";
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
