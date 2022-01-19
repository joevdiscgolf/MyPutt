import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record_putting/components/session_list_row.dart';
import 'package:myputt/screens/record_putting/record_screen.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/session_manager.dart';
import 'package:myputt/screens/record_putting/cubits/sessions_screen_cubit.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<PuttingSession> sessions = locator.get<SessionManager>().allSessions;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionsScreenCubit(),
      child: Navigator(
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
                      BlocBuilder<SessionsScreenCubit, SessionsScreenState>(
                        builder: (context, state) {
                          return Column(
                              children: List.from(state.sessions
                                  .asMap()
                                  .entries
                                  .map((entry) => SessionListRow(
                                      session: entry.value,
                                      index: entry.key + 1))
                                  .toList()
                                  .reversed));
                        },
                      ),
                      BlocBuilder<SessionsScreenCubit, SessionsScreenState>(
                        builder: (context, state) {
                          return PrimaryButton(
                              label: state is! SessionInProgressState
                                  ? 'New session'
                                  : 'Continue session',
                              width: double.infinity,
                              onPressed: () {
                                if (state is NoActiveSessionState ||
                                    state is SessionsScreenInitial) {
                                  PuttingSession _newSession = PuttingSession(
                                      dateStarted:
                                          '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                                      uid: 'myuid');
                                  locator.get<SessionManager>().currentSession =
                                      _newSession;
                                  locator.get<SessionManager>().ongoingSession =
                                      true;
                                  setState(() {
                                    sessions = locator
                                        .get<SessionManager>()
                                        .allSessions;
                                  });
                                  BlocProvider.of<SessionsScreenCubit>(context)
                                      .continueSession();
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider.value(
                                            value: BlocProvider.of<
                                                SessionsScreenCubit>(context),
                                            child: const RecordScreen())));
                              });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
