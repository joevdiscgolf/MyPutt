import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'session_summary_screen.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SessionsCubit>(context).reload();
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: Colors.grey[100]!,
              floatingActionButton: _addButton(context),
              appBar: AppBar(
                title: const Text('Sessions'),
                centerTitle: true,
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<SessionsCubit, SessionsState>(
                  builder: (context, state) {
                    if (state is SessionErrorState) {
                      return Container();
                    } else if (state is SessionInProgressState) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                  '${state.sessions.length} ${state.sessions.length == 1 ? 'Session' : 'Sessions'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                          ),
                          _continueSessionCard(context),
                          _sessionsListView(context),
                        ],
                      );
                    } else if (state is NoActiveSessionState) {
                      return Column(
                        mainAxisAlignment: state.sessions.isEmpty
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: state.sessions.isNotEmpty,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    '${state.sessions.length} ${state.sessions.length == 1 ? 'Session' : 'Sessions'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge),
                              ),
                            ),
                          ),
                          state.sessions.isEmpty
                              ? const Center(
                                  child: Text('No sessions yet'),
                                )
                              : _sessionsListView(context),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Text(
                            '${state.sessions.length} sessions',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          _sessionsListView(context),
                        ],
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _continueSessionCard(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is! SessionInProgressState) {
          return Container();
        } else {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider.value(
                        value: BlocProvider.of<SessionsCubit>(context),
                        child: const RecordScreen())));
              },
              child: SessionListRow(
                isCurrentSession: true,
                delete: () {
                  BlocProvider.of<SessionsCubit>(context)
                      .deleteCurrentSession();
                },
                session: state.currentSession,
                stats: state.currentSessionStats,
              ));
        }
      },
    );
  }

  Widget _sessionsListView(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState) {
          return Flexible(
            fit: FlexFit.loose,
            child: ListView(
                children: List.from(state.sessions
                    .asMap()
                    .entries
                    .map((entry) => InkWell(
                          onTap: () {
                            BlocProvider.of<SessionSummaryCubit>(context)
                                .openSessionSummary(entry.value);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SessionSummaryScreen(
                                        session: entry.value)));
                          },
                          child: SessionListRow(
                              stats: state
                                  .individualStats[entry.value.dateStarted]!,
                              session: entry.value,
                              index: entry.key + 1,
                              delete: () {
                                BlocProvider.of<SessionsCubit>(context)
                                    .deleteSession(entry.value);
                                BlocProvider.of<HomeScreenCubit>(context)
                                    .reloadStats();
                              },
                              isCurrentSession: false),
                        ))
                    .toList()
                    .reversed)),
          );
        } else if (state is NoActiveSessionState) {
          return Flexible(
            fit: FlexFit.loose,
            child: ListView(
                children: List.from(state.sessions
                    .asMap()
                    .entries
                    .map((entry) => InkWell(
                          onTap: () {
                            BlocProvider.of<SessionSummaryCubit>(context)
                                .openSessionSummary(entry.value);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SessionSummaryScreen(
                                        session: entry.value)));
                          },
                          child: SessionListRow(
                              stats: state
                                  .individualStats[entry.value.dateStarted]!,
                              session: entry.value,
                              index: entry.key + 1,
                              delete: () {
                                BlocProvider.of<SessionsCubit>(context)
                                    .deleteSession(entry.value);
                                BlocProvider.of<HomeScreenCubit>(context)
                                    .reloadStats();
                              },
                              isCurrentSession: false),
                        ))
                    .toList()
                    .reversed)),
          );
        } else if (state is SessionErrorState) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('Something went wrong')]);
        } else {
          return const Text('No sessions yet');
        }
      },
    );
  }

  Widget _addButton(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState) {
          return Container();
        }
        return Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              /*style: ElevatedButton.styleFrom(
                         shape: const CircleBorder(),
                         padding: const EdgeInsets.all(20), // <-- Splash color
                       ),*/
              child: const Icon(FlutterRemix.add_line),
              onPressed: () {
                if (state is! SessionInProgressState) {
                  BlocProvider.of<SessionsCubit>(context).startSession();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider.value(
                          value: BlocProvider.of<SessionsCubit>(context),
                          child: const RecordScreen())));
                }
              }),
        );
      },
    );
  }
}
