import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/app_bars/myputt_app_bar.dart';
import 'package:myputt/components/delegates/sliver_app_bar_delegate.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/session_summary/session_summary_screen.dart';
import 'package:myputt/screens/sessions/components/create_new_session_button.dart';
import 'package:myputt/screens/sessions/components/resume_session_card.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/utils/colors.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<SessionsScreen> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  final ScrollController _scrollController = ScrollController();

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
              appBar: MyPuttAppBar(
                title: 'Sessions',
                controller: _scrollController,
                hasBackButton: false,
              ),
              backgroundColor: MyPuttColors.white,
              floatingActionButton: const CreateNewSessionButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
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
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (state is SessionInProgressState)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    ResumeSessionCard(currentSession: state.currentSession),
                  ),
                ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  _mixpanel.track('Sessions Screen Pull To Refresh');
                  Vibrate.feedback(FeedbackType.light);
                  await BlocProvider.of<SessionsCubit>(context)
                      .reloadCloudSessions();
                },
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: state is SessionInProgressState ? 20 : 0,
                  bottom: 32,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return children[index];
                    },
                    childCount: children.length,
                  ),
                ),
              ),
            ],
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
}
