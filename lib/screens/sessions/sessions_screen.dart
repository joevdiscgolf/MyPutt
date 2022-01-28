import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:myputt/bloc/cubits/session_summary_cubit.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';
import 'session_summary_screen.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/screens/components/confirm_delete_dialog.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<SessionsScreen> {
  final StatsService _statsService = locator.get<StatsService>();

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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    BlocBuilder<SessionsCubit, SessionsState>(
                      builder: (context, state) {
                        if (state is SessionErrorState) {
                          return Container();
                        } else {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text('${state.sessions.length} Sessions',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        }
                      },
                    ),
                    _continueSessionCard(context),
                    _sessionsListView(context),
                  ],
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
            child: Card(
              color: Colors.blue[100]!,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(state.currentSession.dateStarted,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Icon(
                            FlutterRemix.close_line,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => ConfirmDeleteDialog(
                                    title: 'Delete Session',
                                    delete: () {
                                      BlocProvider.of<SessionsCubit>(context)
                                          .deleteCurrentSession();
                                      BlocProvider.of<HomeScreenCubit>(context)
                                          .reloadStats();
                                    }));
                          }),
                    )
                  ],
                ),
              ),
            ),
          );

          /*Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.blueAccent[100],
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Continue Session',
                              style: TextStyle(
                                fontSize: 30,
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(state.currentSession.dateStarted),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${state.currentSession.totalPuttsMade} / ${state.currentSession.totalPuttsAttempted} putts',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ]),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider.value(
                              value: BlocProvider.of<SessionsCubit>(context),
                              child: const RecordScreen())));
                    },
                  ),
                ),
              )),
            ],
          );*/
        }
      },
    );
  }

  Widget _sessionsListView(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
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
                                  SessionSummaryScreen(session: entry.value)));
                        },
                        child: SessionListRow(
                            session: entry.value,
                            index: entry.key + 1,
                            delete: () {
                              BlocProvider.of<SessionsCubit>(context)
                                  .deleteSession(entry.value);
                              BlocProvider.of<HomeScreenCubit>(context)
                                  .reloadStats();
                            }),
                      ))
                  .toList()
                  .reversed)),
        );
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
