import 'package:flutter/cupertino.dart';
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
import 'package:myputt/screens/sessions/components/sessions_screen_app_bar.dart';
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
  void initState() {
    super.initState();
    BlocProvider.of<SessionsCubit>(context).reload();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SessionsCubit>(context).reload();
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: SessionsScreenAppBar(
                allSessions: _sessionRepository.allSessions,
              ),
              backgroundColor: MyPuttColors.white,
              floatingActionButton: _addButton(context),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: _mainBody(context),
            );
          },
        );
      },
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState || state is NoActiveSessionState) {
          List<Widget> children = [];
          if (state is SessionInProgressState) {
            children.add(
              SessionListRow(
                session: state.currentSession,
                delete: () {
                  BlocProvider.of<SessionsCubit>(context)
                      .deleteCurrentSession();
                },
                onTap: () {
                  Vibrate.feedback(FeedbackType.light);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider.value(
                        value: BlocProvider.of<SessionsCubit>(context),
                        child: const RecordScreen(),
                      ),
                    ),
                  );
                },
                isCurrentSession: true,
              ),
            );
          }
          children.addAll(
            List.from(
              state.sessions
                  .asMap()
                  .entries
                  .map(
                    (entry) => SessionListRow(
                      session: entry.value,
                      index: entry.key + 1,
                      delete: () {
                        BlocProvider.of<SessionsCubit>(context)
                            .deleteSession(entry.value);
                        BlocProvider.of<HomeScreenCubit>(context).reload();
                      },
                      isCurrentSession: false,
                      onTap: () {
                        Vibrate.feedback(FeedbackType.light);
                        BlocProvider.of<SessionSummaryCubit>(context)
                            .openSessionSummary(entry.value);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SessionSummaryScreen(session: entry.value),
                          ),
                        );
                      },
                    ),
                  )
                  .toList()
                  .reversed,
            ),
          );
          return Padding(
            padding: const EdgeInsets.all(8),
            child: CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    Vibrate.feedback(FeedbackType.light);
                    await BlocProvider.of<SessionsCubit>(context)
                        .reloadSessions();
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(children: children);
                    },
                    childCount: 1,
                  ),
                )
              ],
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider.value(
                    value: BlocProvider.of<SessionsCubit>(context),
                    child: const RecordScreen(),
                  ),
                ),
              );
            }
          },
          title: 'New session',
          textSize: 16,
        );
      },
    );
  }
}
