import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
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
  final Mixpanel _mixpanel = locator.get<Mixpanel>();

  @override
  void initState() {
    _mixpanel.track('Sessions Screen Impression');
    BlocProvider.of<SessionsCubit>(context).emitUpdatedState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: const SessionsScreenAppBar(),
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
                  _mixpanel.track('Sessions Screen Delete Session Confirmed');
                  BlocProvider.of<SessionsCubit>(context)
                      .deleteCurrentSession();
                },
                onTap: () {
                  Vibrate.feedback(FeedbackType.light);
                  _mixpanel.track('Sessions Screen Current Session Row Pressed',
                      properties: {
                        'Set Count': state.currentSession.sets.length,
                      });
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
                            .deleteCompletedSession(entry.value);
                        BlocProvider.of<HomeScreenCubit>(context).reload();
                      },
                      isCurrentSession: false,
                      onTap: () {
                        Vibrate.feedback(FeedbackType.light);
                        _mixpanel.track('Sessions Screen Session Row Pressed',
                            properties: {
                              'Set Count': entry.value.sets.length,
                            });
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
                    _mixpanel.track('Sessions Screen Pull To Refresh');
                    Vibrate.feedback(FeedbackType.light);
                    await BlocProvider.of<SessionsCubit>(context)
                        .reloadCloudSessions();
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
            onRetry: () =>
                BlocProvider.of<SessionsCubit>(context).emitUpdatedState(),
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
            Vibrate.feedback(FeedbackType.light);
            _mixpanel.track(
              'Sessions Screen New Session Button Pressed',
              properties: {'Session Count': state.sessions.length},
            );
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
