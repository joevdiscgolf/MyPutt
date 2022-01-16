import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record_putting/components/session_list_row.dart';
import 'package:myputt/screens/record_putting/record_screen.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/session_service.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final SessionService _sessionService = locator.get<SessionService>();
  List<PuttingSession> sessions = locator.get<SessionService>().allSessions;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Sessions'),
                centerTitle: true,
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Column(
                        children: sessions
                            .map((session) => SessionListRow(session: session))
                            .toList()),
                    PrimaryButton(
                      label: 'New session',
                      width: double.infinity,
                      onPressed: () {
                        if (!locator.get<SessionService>().ongoingSession) {
                          PuttingSession _newSession = PuttingSession(
                              dateStarted: DateTime.now().toString(),
                              uid: 'myuid');
                          locator.get<SessionService>().currentSession =
                              _newSession;
                          locator.get<SessionService>().ongoingSession = true;
                          locator
                              .get<SessionService>()
                              .allSessions
                              .add(_newSession);
                          setState(() {
                            sessions =
                                locator.get<SessionService>().allSessions;
                          });
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const RecordScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
