import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:myputt/screens/sessions/components/session_list_row.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        }
                      },
                    ),
                    _continueSessionPanel(context),
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

  Widget _continueSessionPanel(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is! SessionInProgressState) {
          return Container();
        } else {
          return Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.greenAccent[500],
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
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
          );
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
                  .map((entry) => SessionListRow(
                      session: entry.value,
                      index: entry.key + 1,
                      delete: () {
                        BlocProvider.of<SessionsCubit>(context)
                            .deleteSession(entry.value);
                        BlocProvider.of<HomeScreenCubit>(context).reloadStats();
                      }))
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
