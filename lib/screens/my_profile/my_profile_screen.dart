import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';

import '../../locator.dart';
import '../../services/signin_service.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoaded) {
              return Text(state.myUser.username);
            } else {
              return Text('Loading');
            }
          },
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              locator.get<SigninService>().signOut();
            },
            child: const Text('Logout'),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailsPanel(context),
          Text(
            '${_sessionRepository.allSessions.length} sessions',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 10),
          Text(
            '${_challengesRepository.completedChallenges.length} completed challenges',
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
  }

  Widget _detailsPanel(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
      if (state is MyProfileLoaded) {
        return Row(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Display name: ${state.myUser.displayName}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'username: ${state.myUser.username}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  )),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        );
      }
    });
  }
}
