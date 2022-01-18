import 'package:flutter/material.dart';
import 'package:myputt/screens/record_putting/record_screen.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/session_service.dart';
import 'package:myputt/locator.dart';

class FinishSessionDialog extends StatefulWidget {
  const FinishSessionDialog({Key? key}) : super(key: key);

  @override
  _FinishSessionDialogState createState() => _FinishSessionDialogState();
}

class _FinishSessionDialogState extends State<FinishSessionDialog> {
  String? _dialogErrorText;
  final SessionService? _sessionService = locator.get<SessionService>();

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
                          Navigator.pop(context);
                        }),
                    PrimaryButton(
                      label: 'Finish',
                      fontSize: 18,
                      width: 100,
                      height: 50,
                      backgroundColor: Colors.green,
                      onPressed: () {
                        final List<PuttingSet>? sets =
                            locator.get<SessionService>().currentSession?.sets;
                        if (sets == null || sets.isEmpty) {
                          setState(() {
                            _dialogErrorText = 'Empty session!';
                          });
                        } else {
                          final PuttingSession? currentSession =
                              _sessionService?.currentSession;
                          if (currentSession != null) {
                            _sessionService?.allSessions.add(currentSession);
                          }
                          _sessionService?.ongoingSession = false;
                          Navigator.pop(context);
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
