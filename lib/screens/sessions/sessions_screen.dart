import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'components/active_session_row.dart';
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
              backgroundColor: MyPuttColors.white,
              floatingActionButton: _addButton(context),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<SessionsCubit, SessionsState>(
                  builder: (context, state) {
                    if (state is SessionErrorState) {
                      return Container();
                    } else if (state is SessionInProgressState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 60),
                            child: Text(
                              'Sessions',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontSize: 40, color: MyPuttColors.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            '${state.sessions.length} total',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontSize: 20,
                                    color: MyPuttColors.gray[400]),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
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
                                      .headline6!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24),
                                ),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${state.sessions.length} ${state.sessions.length == 1 ? 'Session' : 'Sessions'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24),
                              ),
                            ),
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
          return Bounceable(
              onTap: () {},
              child: ActiveSessionRow(
                isCurrentSession: true,
                delete: () {
                  BlocProvider.of<SessionsCubit>(context)
                      .deleteCurrentSession();
                },
                session: state.currentSession,
                stats: state.currentSessionStats,
                onTap: () {
                  Vibrate.feedback(FeedbackType.light);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider.value(
                          value: BlocProvider.of<SessionsCubit>(context),
                          child: const RecordScreen())));
                },
              ));
        }
      },
    );
  }

  Widget _sessionsListView(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState || state is NoActiveSessionState) {
          List<Widget> listViewChildren = [];
          if (state is SessionInProgressState) {
            listViewChildren.add(SessionListRow(
              session: state.currentSession,
              delete: () {
                BlocProvider.of<SessionsCubit>(context).deleteCurrentSession();
              },
              onTap: () {
                Vibrate.feedback(FeedbackType.light);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider.value(
                        value: BlocProvider.of<SessionsCubit>(context),
                        child: const RecordScreen())));
              },
              isCurrentSession: true,
            ));
          }
          listViewChildren.addAll(List.from(state.sessions
              .asMap()
              .entries
              .map((entry) => SessionListRow(
                    session: entry.value,
                    index: entry.key + 1,
                    delete: () {
                      BlocProvider.of<SessionsCubit>(context)
                          .deleteSession(entry.value);
                      BlocProvider.of<HomeScreenCubit>(context).reloadStats();
                    },
                    isCurrentSession: false,
                    onTap: () {
                      Vibrate.feedback(FeedbackType.light);
                      BlocProvider.of<SessionSummaryCubit>(context)
                          .openSessionSummary(entry.value);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SessionSummaryScreen(session: entry.value)));
                    },
                  ))
              .toList()
              .reversed));
          return Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              itemCount: listViewChildren.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  listViewChildren[index],
              padding: const EdgeInsets.only(top: 0),
            ),
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
