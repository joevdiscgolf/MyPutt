// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_vibrate/flutter_vibrate.dart';
// import 'package:myputt/components/empty_state/empty_state.dart';
// import 'package:myputt/components/screens/loading_screen.dart';
// import 'package:myputt/cubits/home/home_screen_cubit.dart';
// import 'package:myputt/cubits/session_summary_cubit.dart';
// import 'package:myputt/cubits/sessions_cubit.dart';
// import 'package:myputt/models/data/challenges/putting_challenge.dart';
// import 'package:myputt/models/data/sessions/putting_session.dart';
// import 'package:myputt/screens/challenge/components/challenges_list.dart';
// import 'package:myputt/screens/home/components/calendar_view/performance_calendar_panel.dart';
// import 'package:myputt/screens/home/components/home_screen_tab.dart';
// import 'package:myputt/screens/sessions/components/session_list_row.dart';
// import 'package:myputt/screens/session_summary/session_summary_screen.dart';
// import 'package:myputt/utils/colors.dart';
// import 'package:myputt/utils/enums.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class CalendarView extends StatefulWidget {
//   const CalendarView({Key? key}) : super(key: key);
//
//   @override
//   _CalendarViewState createState() => _CalendarViewState();
// }
//
// class _CalendarViewState extends State<CalendarView>
//     with SingleTickerProviderStateMixin {
//   late ScrollController _scrollController;
//   late TabController _viewTypeController;
//   late DateTime _currentSelectedDate;
//
//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     _viewTypeController = TabController(length: 2, vsync: this);
//     _currentSelectedDate = DateTime.now();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _viewTypeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeScreenCubit, HomeScreenState>(
//       builder: (context, state) {
//         if (state is HomeScreenLoaded) {
//           final List<PuttingSession> sessions = state.allSessions
//               .where(
//                 (session) => isSameDay(
//                   _currentSelectedDate,
//                   DateTime.fromMillisecondsSinceEpoch(session.timeStamp),
//                 ),
//               )
//               .toList();
//           final List<PuttingChallenge> challenges = state.allChallenges
//               .where(
//                 (challenge) => isSameDay(
//                   _currentSelectedDate,
//                   DateTime.fromMillisecondsSinceEpoch(
//                     challenge.completionTimeStamp ??
//                         challenge.creationTimeStamp,
//                   ),
//                 ),
//               )
//               .toList();
//           return NestedScrollView(
//             controller: _scrollController,
//             headerSliverBuilder: (BuildContext context, bool value) {
//               return [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                           padding: const EdgeInsets.only(top: 8),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                                 end: const Alignment(0.8, 0),
//                                 transform:
//                                     const GradientRotation(3 * math.pi / 2),
//                                 colors: [
//                                   MyPuttColors.blue.withOpacity(0.8),
//                                   MyPuttColors.white,
//                                 ]),
//                           ),
//                           child: PerformanceCalendarPanel(
//                             onDateChanged: (DateTime date) =>
//                                 setState(() => _currentSelectedDate = date),
//                           )),
//                       _sessionsAndChallengesTabBar(context),
//                     ],
//                   ),
//                 ),
//               ];
//             },
//             body: TabBarView(
//               controller: _viewTypeController,
//               children: [
//                 _sessionsLists(context, sessions),
//                 ChallengesList(
//                   category: ChallengeCategory.complete,
//                   challenges: challenges,
//                 )
//               ],
//             ),
//           );
//         } else if (state is HomeScreenInitial || state is HomeScreenLoading) {
//           return const LoadingScreen();
//         } else {
//           return EmptyState(
//             onRetry: () => BlocProvider.of<HomeScreenCubit>(context).reload(),
//           );
//         }
//       },
//     );
//   }
//
//   Widget _sessionsLists(BuildContext context, List<PuttingSession> sessions) {
//     return sessions.isEmpty
//         ? const Center(child: Text('No sessions'))
//         : ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             children: sessions
//                 .map(
//                   (session) => SessionListRow(
//                     session: session,
//                     delete: () {
//                       BlocProvider.of<SessionsCubit>(context)
//                           .deleteCompletedSession(session);
//                       BlocProvider.of<HomeScreenCubit>(context).reload();
//                     },
//                     onTap: () {
//                       Vibrate.feedback(FeedbackType.light);
//                       BlocProvider.of<SessionSummaryCubit>(context)
//                           .openSessionSummary(session);
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (BuildContext context) =>
//                               SessionSummaryScreen(session: session)));
//                     },
//                   ),
//                 )
//                 .toList(),
//           );
//   }
//
//   Widget _sessionsAndChallengesTabBar(BuildContext context) {
//     return Container(
//       color: MyPuttColors.white,
//       height: 60,
//       child: TabBar(
//         controller: _viewTypeController,
//         labelPadding: const EdgeInsets.all(0),
//         indicatorPadding: const EdgeInsets.all(0),
//         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         labelColor: Colors.blue,
//         unselectedLabelColor: Colors.black,
//         indicator: const UnderlineTabIndicator(
//             borderSide: BorderSide(color: MyPuttColors.blue)),
//         tabs: const [
//           HomeScreenTab(
//             label: 'Sessions',
//           ),
//           HomeScreenTab(label: 'Challenges'),
//         ],
//       ),
//     );
//   }
// }
