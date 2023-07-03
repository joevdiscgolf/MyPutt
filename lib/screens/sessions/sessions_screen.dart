import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/app_bars/myputt_app_bar.dart';
import 'package:myputt/components/delegates/sliver_app_bar_delegate.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/empty_state/empty_state_v2.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/screens/sessions/components/create_new_session_button.dart';
import 'package:myputt/screens/sessions/components/resume_session_card.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/screens/sessions/components/session_loading_screen.dart';
import 'package:myputt/utils/colors.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static const String routeName = '/sessions';
  static const String screenName = 'Sessions';

  @override
  State<SessionsScreen> createState() => _SessionsState();
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
                topViewPadding: MediaQuery.of(context).viewPadding.top,
              ),
              backgroundColor: MyPuttColors.white,
              body: Stack(
                children: [
                  _mainBody(context),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: CreateNewSessionButton(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, sessionState) {
        if (sessionState is SessionLoadingState) {
          return const SessionLoadingScreen();
        } else if (sessionState is SessionErrorState) {
          return EmptyState(
            onRetry: () =>
                BlocProvider.of<SessionsCubit>(context).reloadCloudSessions(),
          );
        } else if (sessionState is! SessionActive &&
            sessionState.sessions.isEmpty) {
          return const EmptyStateV2(
            title: 'No sessions yet...',
            subtitle: 'Start a session using the "+" button.',
            iconData: FlutterRemix.stack_line,
          );
        }

        final List<Widget> children =
            sessionState.sessions.reversed.map((PuttingSession session) {
          return SessionListRow(session: session);
        }).toList();

        return CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                _mixpanel.track('Sessions Screen Pull To Refresh');
                Vibrate.feedback(FeedbackType.light);
                await BlocProvider.of<SessionsCubit>(context)
                    .reloadCloudSessions();
              },
            ),
            if (sessionState is SessionActive)
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  ResumeSessionCard(
                      currentSession: sessionState.currentSession),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: sessionState is SessionActive ? 20 : 0,
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
      },
    );
  }
}
