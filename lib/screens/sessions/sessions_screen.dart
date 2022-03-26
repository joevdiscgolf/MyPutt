import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'session_summary_screen.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<SessionsScreen> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SessionsCubit>(context).reload();
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Sessions',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 40, color: MyPuttColors.blue),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                backgroundColor: MyPuttColors.white,
                floatingActionButton: _addButton(context),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                body: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            _sessionRepository.allSessions.isEmpty
                                ? 'No sessions yet'
                                : '${_sessionRepository.allSessions.length} total',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    fontSize: 20,
                                    color: MyPuttColors.gray[400]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        _sessionsListView(context),
                      ],
                    )),
              );
            });
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
        } else {
          return EmptyState(
            onRetry: () => BlocProvider.of<SessionsCubit>(context).reload(),
          );
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
        return MyPuttButton(
          iconData: FlutterRemix.add_line,
          width: MediaQuery.of(context).size.width / 2,
          shadowColor: MyPuttColors.gray[400],
          onPressed: () {
            if (state is! SessionInProgressState) {
              BlocProvider.of<SessionsCubit>(context).startNewSession();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider.value(
                      value: BlocProvider.of<SessionsCubit>(context),
                      child: const RecordScreen())));
            }
          },
          title: 'New session',
        );
      },
    );
  }
}
