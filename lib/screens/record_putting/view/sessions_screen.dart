import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/screens/record_putting/view/components/session_list_row.dart';
import 'package:myputt/screens/record_putting/view/record_screen.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/screens/record_putting/cubits/sessions_screen_cubit.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static String routeName = '/sessions_screen';

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Sessions'),
                centerTitle: true,
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    BlocBuilder<SessionsScreenCubit, SessionsScreenState>(
                      builder: (context, state) {
                        return Column(
                            children: List.from(state.sessions
                                .asMap()
                                .entries
                                .map((entry) => SessionListRow(
                                    session: entry.value,
                                    index: entry.key + 1,
                                    delete: () {
                                      BlocProvider.of<SessionsScreenCubit>(
                                              context)
                                          .deleteSession(entry.value);
                                    }))
                                .toList()
                                .reversed));
                      },
                    ),
                    BlocBuilder<SessionsScreenCubit, SessionsScreenState>(
                      builder: (context, state) {
                        return PrimaryButton(
                            label: state is SessionInProgressState
                                ? 'Continue session'
                                : 'New session',
                            width: double.infinity,
                            onPressed: () {
                              if (state is SessionInProgressState) {
                                BlocProvider.of<SessionsScreenCubit>(context)
                                    .continueSession();
                              } else {
                                BlocProvider.of<SessionsScreenCubit>(context)
                                    .startSession();
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider.value(
                                          value: BlocProvider.of<
                                              SessionsScreenCubit>(context),
                                          child: const RecordScreen())));
                            });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
